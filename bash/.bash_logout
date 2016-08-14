# ~/.bash_logout

# Invalidate the sudo permission timestamp for this session
sudo -k

# Clear the screen and scrollback buffer
if [[ $SHLVL = 1 ]]; then
    /usr/bin/clear
fi
