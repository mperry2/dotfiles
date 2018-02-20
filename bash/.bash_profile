# .bash_profile
#echo ".bash_profile: Entering"

# Get the aliases and functions
if [[ -f ~/.bashrc ]]; then
    source ~/.bashrc
fi

# User specific environment and startup programs
if [[ $LANG == *"UTF-8" ]]; then
    echo -e "\e[38;5;212m──────────\e[0m"
else
    echo -e "\e[38;5;212m----------\e[0m"
fi

echo "Term set to $TERM"
[[ -x ~/bin/show-os ]] && ~/bin/show-os
[[ -x $(type -p uptime) ]] && uptime
true

#echo ".bash_profile: Leaving"
