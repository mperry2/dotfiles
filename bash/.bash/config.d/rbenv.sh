#
# rbenv
#
#if    [[ $OSTYPE = 'linux-gnu' ]] \
#   && [[ $HOSTTYPE = 'x86_64' ]] \
#   && [[ $(sed -r 's/.*release ([0-9])\..*/\1/g;tx;d;:x' /etc/redhat-release 2>/dev/null) -ge 6 ]]
#then
    if [[ -r ~/.rbenv ]]; then
        pre_path $HOME/.rbenv/bin
        eval "$(rbenv init -)"
    fi
#fi
add_path $HOME/.gem/ruby/1.8/bin
