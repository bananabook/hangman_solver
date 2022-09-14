## Solves the hangman game from bsdgames if it is running in the 0 pane in the same tmux window
# How to run?
# 1. install tmux and hangman
# 2. start tmux
# 3. start hangman
# 4. break the tmux pane (default ctrl+b ")
# 5. start this script

# Known problems
# 1. Some words like "muffin" and "capping" defeat this solver. With the best strategy it takes too long to solve them.
# 2. The game commands will be sent to the 0 pane in the current window, if you change to another window, the 0 pane there will receive the game commands. Stop the script before changing windows in tumx

# Unknown problems
# when solving the word "capping" sth weird happened, would require investigations

# the solve function takes a capture and makes the next guess
solve(){
	# capture the pane and store it in the tmux buffer with the name "screen", then store this capture in the file "all"
#	t capture-pane -t 0 -b screen
#	t save-buffer -b screen ./all
	# look for the word so far, it will look sth like --llo for the word "hello" if we guessed l and o so far
	word=$(grep -P "^ Word" all|sed 's/^ Word:\s* \(\S\S*\)$/\1/g')
	# we need to determine what guesses we already made
	used=$(grep -P "Guessed:" all|sed 's/^.*Guessed:\s*//g')
	# if we alredy guessed sth we need to analyse further, otherwise we just guess e (the most common character)
	if [[ ${#used} -ne 0 ]];then
		# hangman reads from the file /usr/share/dict/words we search for possible words based on the word so far. This search is facilitated by a regular expression, which looks for words, that do not contain an apostrophe and would match the word so far
		reg=$(echo -n "^";echo -n $word|sed "s/\-/\[^${used}]/g";echo "$")
		possible=$(grep -P "$reg" /usr/share/dict/words|grep -v "'"|tr 'A-Z' 'a-z')
		
		# the variable possible now contains the possible words, we remove the character we already guessed and then search for the most common character among these possible words to make the best possible guess
		common=$(echo $possible |tr -d ' '|sed "s:[$used]::g"|fold -w1|sort|uniq -c|sed 's:^\s*::g'|sort -n)
		next=$(echo "$common"|tail -n1|awk '{print $2}')
		
		# then we send this best guess
		t send -t 0 "$next"
	else
		t send -t 0 "e"
	fi
}

# Here is the main
while true;do 
	# we capture the pane and store it in the file all
	t capture-pane -t 0 -b screen
	t save-buffer -b screen ./all
	# Did we already win? If so the string "You got it!" will be found
	if grep -q "You got it!" all;then
		# We won, we print out, that we won and then send y to play another game
		echo ":) we go it"
		sleep 0.1
		t send -t 0 "y"
	# if we did not win and question mark appears, it means we have lost
	elif grep -q "?" all;then
		we say we lost and send y to play another game
		echo ":( we lost"
		sleep 0.5
		t send -t 0 "y"
	else
		# we neither won nor lost, so we make another guess, that brings us closer by calling the solve function
		sleep 0.1
		solve
	fi
done
