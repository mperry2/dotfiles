# Make sure the sudoedit command line is passed to the editor so it can use it
# to set the correct filetype.

if [[ -e $(command -v sudoedit) && -x $(realpath "$(command -v sudoedit)") ]]; then
  sudoedit() {
    SUDO_COMMAND="sudoedit $*" command sudoedit "$@"
  }
fi
