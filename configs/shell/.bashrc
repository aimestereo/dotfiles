# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
if [ -f ~/.local/share/omarchy/default/bash/rc ]; then
	source ~/.local/share/omarchy/default/bash/rc
fi

source ~/.config/shell/bashrc
