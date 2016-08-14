#
# pyenv
#
#if    [[ $OSTYPE = 'linux-gnu' ]] \
#   && [[ $HOSTTYPE = 'x86_64' ]] \
#   && [[ $(sed -r 's/.*release ([0-9])\..*/\1/g;tx;d;:x' /etc/redhat-release 2>/dev/null) -ge 6 ]]
#then
#    export PYENV_ROOT="${HOME}/.pyenv"
#    if [[ -d "${PYENV_ROOT}" ]]; then
#        pre_path ${PYENV_ROOT}/bin
#        eval "$(pyenv init -)"
#    fi
#fi
