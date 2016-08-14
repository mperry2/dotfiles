#
# Perlbrew
#
if [[ -d ${PERLBREW_ROOT:=$HOME/perl5/perlbrew} ]]; then
    source $PERLBREW_ROOT/etc/bashrc
    source $PERLBREW_ROOT/etc/perlbrew-completion.bash
fi
