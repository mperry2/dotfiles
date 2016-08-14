#!/bin/bash
#
# cd.sh -- Enhanced cd
#
# $Id: cd.sh,v 1.6 2006/01/01 23:56:55 matt Exp $
#
# DESCRIPTION
#      This function replaces the internal "cd" command to provide a more
#      powerful version with some amenities. Some of the features included are
#
#      o  "ls" can be optionally executed after each directory change
#
#      o  if the target is a file, cd will change to the dir containing the
#         file
#
#      o  if the target is a jobspec, cd will change to the working directory
#         of the job
#
#      o  replace a substring of your current path to change directories
#
#      o  easily step forward or back through a series of directories to view
#         their contents
#
#      o  quickly enter the first or last directory within the current
#         directory
#
#      o  history of the last 10 unique directories is kept with the ability to
#         quickly return to any of them
#
#      o  emacs-style keyboard shortcuts
#
#
# OPTIONS
#      -f  Go to first subdirectory in current directory
#
#      -l  Go to last subdirectory in current directory
#
#      -b  Go to first subdirectory in parent dir
#
#      -e  Go to last subdirectory in parent dir
#
#      -n  Go to next subdirectory in parent dir
#
#      -p, -r
#          Go to previous subdirectory in parent dir
#
#      -d  Show directories in dir stack
#
#      -0..9
#          Change to dir number in stack
# 
#
# USAGE
#   Directory Listing
#      If the environment variable CD_ENABLE_LS is set then after each
#      directory change "ls" is executed to list the directory contents.
#
#   Specifying Paths
#      If the path you provide ends in a filename the directory will be
#      changed to the one containing the file rather than issuing an error.
#
#      If the path is a jobspec the directory will be changed to the working
#      directory of the specified jobspec.
#
#      If two arguments are supplied the first one will used as a substring to
#      search for within your current path.  The second argument will replace
#      any match of the first argument in the path and then change directories.
#      For example, imagine that you have two directories:
#
#          /usr/local/share/foo/etc/data
#            and
#          /usr/local/share/bar/etc/data
#
#      If you accidentally went to /usr/local/share/foo/etc/data and meant to
#      go to the other directory then entering:
#
#          cd foo bar
#
#      would change your directory to /usr/local/share/bar/etc/data.
#
#   Navigating Directories
#      When invoked with the -f option the directory will be changed to the
#      first subdirectory (alphabetically) in the current directory.  When
#      invoked with the -l option the directory will be changed to the last
#      subdirectory in the current directory.
#
#      When invoked with the -p or -n options the directory will be changed to
#      the previous or next directory parallel to the current directory.  For
#      example, say you have the following subdirectory structure within your
#      current directory: a, b, c, d, e.  The following commands will change to
#      the listed directory:
#
#          cd -f
#              current directory is now "a"
#
#          cd -n
#              current directory is now "b"
#
#          cd -n
#              current directory is now "c"
#
#          cd -p
#              current directory is now "b"
#
#          cd .. && cd -l
#              current directory is now "e"
#
#          cd -p
#              current directory is now "d"
#
#          cd -b
#              current directory is now "a"
#
#          cd -e
#              current directory is now "e"
#
#      The -r option performs the same function as the -p option.
#
#   History
#      A history of directory changes is kept on a stack using the bash
#      DIRSTACK variable and the pushd/popd commands.  Up to 10 directories are
#      kept and duplicates are removed after each directory change.
#
#      When invoked with the -d option cd will output the history prefixed by a
#      number.  Invoking cd with a given number as an option will change to
#      that directory.
#
#      If the environment variable CD_ENABLE_HISTSAVE is set then after
#      changing directories the current directory stack will be written to
#      ~/.dirstack.  This allows the directory stack to be prepopulated when a
#      new shell is started rather than starting with an empty stack.  When this
#      file is sourced, the stack will be populated if the ~/.dirstack file is
#      found.
#
#   Keyboard Shortcuts
#      If you are using Bash 2.05a or newer then several keyboard shortcuts are
#      available.
#
#      "C-XC-D"  Show directories in dir stack
#      "C-XC-N"  Go to next subdirectory in parent dir
#      "C-XC-P"  Go to previous subdirectory in parent dir
#      "C-Xn"    Change to dir number n in stack
#
#      Please read the section BUGS below regarding issues with this.
#
#
# AUTHOR
#      Matt Perry <matt@mattperry.com>
#
#      ... but was really cobbled together from code taken from
#
#      Petar Marinov
#        (http://www.geocities.com/h2428/petar/bash_acd.htm)
#      Chet Ramey
#        (http://lists.gnu.org/archive/html/bug-bash/2002-05/msg00142.html)
#      Christoph Berg
#        (http://www.df7cb.de/projects/conf/.env)
#
#
# BUGS
#      There is a bug in bash that prevents updating of the prompt when
#      directory changes take place with the keyboard shortcuts.  If your
#      prompt shows the current directory it will not be updated after using
#      the keyboard shortcuts to change directories until you hit the return
#      key or execute another command.  Tested with bash 2.05b and 3.00.16.
#
#      When changing to a directory that contains spaces in the path some
#      "unknown command" errors will display.


# Populate $jwd with the working directory for a given jobspec
_jwd() {
    local j
    jwd=            # global
    j=$(jobs "$1")
    [ -z "$j" ] && return;
    case "$j" in
    *\(wd:*)        jwd=${j##*\(wd: } ; jwd=${jwd%?} ;;
    *)              return ;;
    esac
}


cd () {
    local dir arg opt x2 OPTIND OPTERR
    local -i cnt
    while getopts "0123456789flbenprLPd" opt ; do
        case $opt in
        [0-9]) dir=$(dirs -l +${1:1:1})
               [ -z "$dir" ] && return 1 ;;
        f)     dir=$(find . -maxdepth 1 -type d -name \* | sort | head -n 1)
               [ -z "$dir" ] && return 1 ;;
        l)     dir=$(find . -maxdepth 1 -type d -name \* | sort -r | head -n 1)
               [ -z "$dir" ] && return 1 ;;
        b)     dir=$(find .. -maxdepth 1 -type d -name \* | sort | head -n 1)
               [ -z "$dir" ] && return 1 ;;
        e)     dir=$(find .. -maxdepth 1 -type d -name \* | sort -r | head -n 1)
               [ -z "$dir" ] && return 1 ;;
        n)     dir=$(find .. -maxdepth 1 -type d | sort | sed "1,/..\/$(basename "$PWD")\$/d;q")
               [ -z "$dir" ] && return 1 ;;
        p|r)   dir=$(find .. -mindepth 1 -maxdepth 1 -type d | sort -r | sed "0,/..\/$(basename "$PWD")\$/d;q")
               [ -z "$dir" ] && return 1 ;;
        L|P)   arg="-$opt" ;;
        d)     dirs -v && return 0 ;;
        esac
    done
    shift $(($OPTIND - 1))

    if [ -z "$dir" ]; then
        # If two targets, replace 1st string with 2nd, then cd
        if [ -n "$2" ]; then
            dir="${PWD/$1/$2}"
        else
            dir="$1"
        fi

        # If target is a jobspec, cd to working dir of job
        if [ x${1:0:1} = x"%" ]; then
            _jwd $1
            [ -n "$jwd" ] && dir="$jwd"
        fi

        # If target is a file, cd to dir of file
        if [ -f "${1}" ]; then
            dir="$(dirname "${1}")"
        fi
    fi

    # Go to the home directory if no dir specified
    dir="${dir:-$HOME}"

    # We use the built-in cd to change dirs. The output is redirected to
    # /dev/null to suppress the output of the directory that we've changed to.
    if builtin cd $arg "$dir" >/dev/null; then
        [ -n "$CD_ENABLE_LS" ] && ls

        pushd -n "$OLDPWD" >/dev/null

        # Remove any other occurence of this dir, skipping the top of the stack
        for ((cnt=1; cnt < 10; cnt++)); do
          x2=$(dirs -l +${cnt} 2>/dev/null)
          [[ $? -ne 0 ]] && continue
          if [[ "${x2}" == "${PWD}" ]]; then
            popd -n +$cnt >/dev/null 2>&1
            cnt=cnt-1
          fi
        done

        # Trim down everything beyond 10th entry
        popd -n +10 >/dev/null 2>&1

        [ -n "$CD_ENABLE_HISTSAVE" ] && dirs -l -p >~/.dirstack
    fi
}


# Define keyboard shortcuts for bash
if [[ $BASH_VERSION > "2.05a" ]]; then
    # C-xC-d shows the menu
    bind -x "\"\C-x\C-d\":cd -d ;"

    # C-x[0-9] changes to that dir
    for i in 0 1 2 3 4 5 6 7 8 9; do
      bind -x "\"\C-x${i}\":cd -${i} ;"
    done

    # C-x C-n for next directory
    bind -x "\"\C-x\C-n\":cd -n ;"

    # C-x C-p for previous directory
    bind -x "\"\C-x\C-p\":cd -p ;"
fi


# Initialize the directory stack from the save file
if [ -f ~/.dirstack ]; then 
  # Re-populate old working directory
  OLDPWD="$(head -1 ~/.dirstack)"

  {
  while read -r line <&3; do
    pushd -n "$line" >/dev/null
  done
  } 3<< EOF 
$(grep -v "^${PWD}$" ~/.dirstack | head -9 | tac)
EOF
fi
