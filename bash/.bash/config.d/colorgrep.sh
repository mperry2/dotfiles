if echo 1 | grep --color=auto 1 >/dev/null 2>&1
then
    alias grep='grep --color=auto'
fi
