# .bashrc

# Source global definitions
if [[ -f /etc/bashrc ]]; then
    source /etc/bashrc
fi

# Quit if STDIN is not a terminal
if [[ ! -t 0 ]]; then
    export PATH=$PATH:$HOME/bin
    return 0;
fi
#echo ".bashrc: Entering"


# =============================================================================
# }}} Path initialization                                                  {{{1
# =============================================================================

# is $1 missing from $2 (or PATH) ?
no_path() {
  eval "case :\$${2-PATH}: in *:$1:*) return 1;; *) return 0;; esac"
}
# if $1 exists and is not in path, append it
add_path () {
  [[ -d ${1:-.} ]] && no_path $* && eval ${2:-PATH}="\$${2:-PATH}:$1"
}
# if $1 exists and is not in path, prepend it
pre_path () {
  [[ -d ${1:-.} ]] && no_path $* && eval ${2:-PATH}="$1:\$${2:-PATH}"
}
# if $1 is in path, remove it
del_path () {
  no_path $* || eval ${2:-PATH}=`eval echo :'$'${2:-PATH}: |
    sed -e "s;:$1:;:;g" -e "s;^:;;" -e "s;:\$;;"`
}

# Set PATH so it includes user's private binary directory if it exists.
pre_path $HOME/sbin
pre_path $HOME/opt/bin
pre_path $HOME/bin/$MACHTYPE
pre_path $HOME/bin/scripts
pre_path $HOME/bin
export PATH

# Set MANPATH so it includes user's private manpage directory if it exists.
pre_path $HOME/share/man MANPATH
pre_path $HOME/man MANPATH
export MANPATH

if [[ -d $HOME/.config/sqlplus ]]; then
    SQLPATH=$HOME/.config/sqlplus
fi
pre_path $HOME/sql SQLPATH
export SQLPATH

# =============================================================================
# }}} Shell environment and settings                                       {{{1
# =============================================================================

# Bash customizations
shopt -s cdspell        # Let the shell correct minor typos
shopt -s checkhash      # Verify that cached commands exist before execution
shopt -s checkwinsize   # Update LINES and COLUMNS as necessary
shopt -s cmdhist        # Save multi-line commands in a single history entry
shopt -s expand_aliases
shopt -s extglob        # Extended pattern matching facilities
shopt -s histappend     # Append to history file rather than overwrite
shopt -s interactive_comments     # Allow comments on command line
shopt -s lithist        # Save multi-line commands with embedded newlines
shopt -s no_empty_cmd_completion  # Do not complete on nothing
shopt -s progcomp       # Enable programmable completion
shopt -s promptvars
shopt -s sourcepath
export LINES COLUMNS

# Bash settings
FUNCNEST=100               # Limit recursion in functions (in bash 4.2)
IGNOREEOF=1                # Exit at the second EOF to prevent accidental logouts
HISTFILE=~/.bash_hist      # Separate history file so it's not accidentally deleted
HISTSIZE=10000             # At most 10000 history entries. We want a lot of history.
HISTCONTROL=ignoreboth     # No history for duplicate cmds or cmds starting with space
HISTTIMEFORMAT='[%F %T]  ' # Prepend the command's execution date to history

# Do not save any of the following commands in the shell history
HISTIGNORE='&'          # Matches the previous history line
HISTIGNORE+=':h:history'
HISTIGNORE+=':ls:ll:la:l.:ls -?(l|la|al)'
HISTIGNORE+=':j:jobs:[bf]g:exit:logout:clear:pwd'
HISTIGNORE+=':sudo su -*'

# Filenames ending with these are ignored when using tab completion
FIGNORE='~'             # Backup files created by many editors end in a tilde
FIGNORE+=':.bak'
FIGNORE+=':.BAK'
FIGNORE+=':.class'      # Java compiled bytecode
FIGNORE+=':.DS_Store'
FIGNORE+=':.elc'        # Emacs Lisp compiled bytecode
FIGNORE+=':.git'
FIGNORE+=':.o'
FIGNORE+=':.pyc'        # Python compiled bytecode
FIGNORE+=':.pyd'        # Python script compiled as a Windows DLL
FIGNORE+=':.pyo'        # Optimized pyc file (deprecated as of Python 3.5)
FIGNORE+=':.svn'
FIGNORE+=':.swp'

# =============================================================================
# }}} Program environment                                                  {{{1
# =============================================================================

# Settings for programs
export GREP_COLORS='mt=38;5;0;48;5;191:fn=38;5;147:ln=38;5;178:se=38;5;244:bn=38;5;148' # Normal
export LESS='-c -i -M -R -j3 --shift 5'
export MAKEFLAGS="-j $(grep -c ^processor /proc/cpuinfo 2>/dev/null || echo 2)"
export MORE='-d'
export RLWRAP_HOME=$HOME/.config/rlwrap
export RSYNC_PARTIAL_DIR='.rsync-partial'
export RSYNC_RSH=$(type -p ssh)
export ZIPINFO='-z'

# Colors for less
# Set LESS_TERMCAP_DEBUG to a value to have less show the codes it uses for output.
# blink
export LESS_TERMCAP_mb=$(tput bold; tput setaf 1)
# bold
export LESS_TERMCAP_md=$(tput bold; tput setaf 228)  ## 228 light yellow
export LESS_TERMCAP_me=$(tput sgr0)
# standout
#export LESS_TERMCAP_so=$'\E[1;39;41m'     # Status line: White on red
export LESS_TERMCAP_se=$(tput sgr0)
# underline
export LESS_TERMCAP_us=$(tput smul; tput setaf 218)  ## 218 light pink
export LESS_TERMCAP_ue=$(tput sgr0)

# Needed for less to display colors in Cygwin
if [[ $OSTYPE == 'cygwin' ]]; then
    export GROFF_NO_SGR=yes
fi

# Preferred utility programs
if [[ $OSTYPE == 'cygwin' ]]; then
    export BROWSER=$(type -p cygstart)
else
    export BROWSER=$(type -p elinks || type -p links || type -p lynx)
fi
export PAGER=$(type -p less || type -p more)
export EDITOR=$(type -p vim || type -p vi)
export VISUAL=$EDITOR
export TEXTEDIT=$EDITOR       # Some programs use TEXTEDIT instead

# Configure DISPLAY to use local X server if on Cygwin and DISPLAY is not set
if [[ $OSTYPE == 'cygwin' && -z $DISPLAY ]]; then
    export DISPLAY=localhost:0.0

    # Unset DISPLAY if the X server can't be reached
    if [[ -x ${HOME}/bin/${MACHTYPE}/check-for-x ]]; then
        ${HOME}/bin/${MACHTYPE}/check-for-x || unset DISPLAY
    fi
fi

# =============================================================================
# }}} User-specific aliases and functions                                  {{{1
# =============================================================================

# Safety aliases. Ask for confirmation before overwriting.
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# For ksh compatibility
alias whence='type -a'
alias print='echo'
alias r='fc -s'

# Fix for vim's ex
alias ex='ex -u ~/.exrc'

# Job control
alias j='jobs -l'
alias f1='fg %1'
alias f2='fg %2'
alias f3='fg %3'
alias f4='fg %4'
alias f5='fg %5'
alias f6='fg %6'
alias f7='fg %7'
alias f8='fg %8'
alias f9='fg %9'
alias k1='kill %1'
alias k2='kill %2'
alias k3='kill %3'
alias k4='kill %4'
alias k5='kill %5'
alias k6='kill %6'
alias k7='kill %7'
alias k8='kill %8'
alias k9='kill %9'

# ls mutations
alias ll='ls -l'
alias lf='ls -FC'
alias lr='ls -lR'
alias la='ls -la'
alias lt='ls -lt'
alias ltr='ls -ltr'
alias lsd='ls -ld'
alias lss='ls -ls'

alias pacman='pacman --color=auto'
alias yum='yum --color=auto'

if [[ $(basename $EDITOR) == 'vim' ]]; then
    alias vi=vim
fi

# Autoloading
export FPATH=$HOME/.bash/functions
source $HOME/.bash/autoload.v3

autoload manopt
autoload print-path
autoload run-cssh
autoload up
#autoload which

# =============================================================================
# }}} Term settings                                                        {{{1
# =============================================================================

# Disable XON/XOFF flow control
stty -ixon

if    [[ $TERM == 'xterm' ]] \
   && [[ -n $(toe -a 2>/dev/null | grep xterm-256color 2>/dev/null) ]];
then
    TERM=xterm-256color
fi

if [[ $OSTYPE =~ 'solaris' ]]; then
    TERM=xterm
fi

# =============================================================================
# }}} Software package configuration                                       {{{1
# =============================================================================

#
# Bash completion
#
if [[ -r ~/.bash/bash_completion.sh ]]; then
    source ~/.bash/bash_completion.sh
fi

#
# Git completion
#
if git --version &>/dev/null; then
    source ~/.bash/git-completion.bash
fi

# =============================================================================
# }}} Shell prompt configuration                                           {{{1
# =============================================================================

source $HOME/.bash/git-prompt.sh
PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]$(__git_ps1 " (%s)")\$ '
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWUPSTREAM="auto"
GIT_PS1_SHOWCOLORHINTS=1

PROMPT_COMMAND='__git_ps1 "\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]" "\\\$ "'

#export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'

# Limit directories shown in prompt to 3
#PROMPT_DIRTRIM=3

# To be run by the PROMPT_COMMAND variable, so that one can see what
# the exit status of processes are.
check_exit_status() {
    local status="$?"
    local signal=""

    if [[ ${status} -ne 0 ]] && [[ ${status} != 128 ]]; then
        # If process exited by a signal, determine name of signal.
        if [[ ${status} -gt 128 ]]; then
            signal="$(builtin kill -l $((${status} - 128)) 2>/dev/null)"
            if [[ "$signal" ]]; then signal=" ($signal)"; fi
        fi
        echo "[Exit ${status}${signal}]" 1>&2
    fi
    return 0
}

check_hist_status() {
    if [[ -z $HISTFILE ]]; then
        echo '[HISTOFF]' 1>&2
    fi
    return 0
}

# Prepend our command to any existing value of PROMPT_COMMAND
PROMPT_COMMAND="check_exit_status; check_hist_status; $(echo $PROMPT_COMMAND)"


# =============================================================================
# }}} Domain- and host-specific configuration                              {{{1
# =============================================================================

# Read generic configuration files
for i in ~/.bash/config.d/*.sh ; do
    if [[ -r "$i" ]]; then
        if [[ "${-#*i}" != "$-" ]]; then
            source "$i"
        else
            source "$i" >/dev/null 2>&1
        fi
    fi
done

# Read the domain-specific configuration file
if [[ -r ~/.bash/config-domain.d/$(hostname --domain).sh ]]; then
    source ~/.bash/config-domain.d/$(hostname --domain).sh
fi

# Read the host-specific configuration file
if [[ -r ~/.bash/config-host.d/$(hostname --fqdn).sh ]]; then
    source ~/.bash/config-host.d/$(hostname --fqdn).sh
fi

# }}}

#echo ".bashrc: Leaving"

# vim: fdm=marker:foldlevel=2
