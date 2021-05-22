# ~/.bash_logout

# Invalidate the sudo permission timestamp for this session.
# Run it in the background since SSSD can be slow sometimes.
if which sudo >/dev/null 2>&1; then
    sudo -k &
fi

# Clear the screen and scrollback buffer
if [[ $SHLVL = 1 ]]; then
    /usr/bin/clear
fi
