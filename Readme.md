# hangman solver
hangman is a game contained in the bsdgames collection. You can play it by installing the bsdgames package and run hangman.
This script takes captures of the game and makes the best possible guesses as to how to win.

# Prerequisites
bsdgames
tmux

# How to run?
1. install tmux and hangman (on debian-based systems like ubuntu: apt install -y bsdgames tmux)
2. start tmux
3. start hangman
4. break the tmux pane (default ctrl+b ")
5. start this script

# Known problems
1. Some words like "muffin" and "capping" defeat this solver. With the best strategy it takes too long to solve them.
2. The game commands will be sent to the 0 pane in the current window, if you change to another window, the 0 pane there will receive the game commands. Stop the script before changing windows in tumx

# Unknown problems
When solving the word "capping" sth weird happened, would require investigations.
