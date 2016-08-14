if declare -f autoload >/dev/null; then
    autoload catng
    autoload console
    autoload shownifconfig
fi

# AccuRev client
if [[ -d /nif/tools/accurev/accurev/latest/x86_64-linux/bin ]]; then
    add_path /nif/tools/accurev/accurev/latest/x86_64-linux/bin
fi

# Oracle client
if [[ -d /app/tools/oracle/11.2/x86-64-linux/oracle/product/11.2.0/client ]]; then
    export ORACLE_HOME="/app/tools/oracle/11.2/x86-64-linux/oracle/product/11.2.0/client"
    add_path $ORACLE_HOME/bin
fi

# OEM12c R4 agent
#if [[ -d /monitor/oracle/product/Agent12c/agent_inst ]]; then
#    export AGENT_HOME=/monitor/oracle/product/Agent12c/agent_inst
#
#    emctl() {
#        sudo -u oracle $AGENT_HOME/bin/emctl "$@"
#    }
#    #opatch() {
#    #    sudo -u oracle /monitor/oracle/product/Agent12c/core/12.1.0.4.0/oui/bin/runInstaller "$@"
#    #}
#    #runInstaller() {
#    #    sudo -u oracle /monitor/oracle/product/Agent12c/core/12.1.0.4.0/OPatch/opatch "$@"
#    #}
#fi

# Java (JDK)
# Use the JDK in /app/tools if it exists or fall back to the OEM agent's JDK.
if [[ -d /app/tools/oracle/x86-64-linux/jdk/7/jdk1.7.0_79 ]]; then
    export JAVA_HOME=/app/tools/oracle/x86-64-linux/jdk/7/jdk1.7.0_79
    pre_path $JAVA_HOME/bin
elif [[ -d /monitor/oracle/product/Agent12c/core/12.1.0.4.0/jdk ]]; then
    export JAVA_HOME=/monitor/oracle/product/Agent12c/core/12.1.0.4.0/jdk
    pre_path $JAVA_HOME/bin
fi

# emcli
if [[ -d ~/bin/emcli ]]; then
    export EMCLI_OMS_URL='https://nifoem.llnl.gov/em'
    export EMCLI_TRUSTALL='true'
    pre_path $HOME/bin/emcli
fi


# Ignore SSL certificate validation. We don't have the lab's CA certs installed
# everywhere.
export PERL_LWP_SSL_VERIFY_HOSTNAME=0


# Use NIF's CPAN mirror
export PERL_CPANM_OPT='--mirror-only --mirror http://mirrors.llnl.gov/CPAN/'
