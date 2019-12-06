# Homebrew related bashrc.
#

HOMEBREW="/usr/local/bin/brew"

if [ -x "$HOMEBREW" ] ; then
    BREW_PREFIX=$($HOMEBREW --prefix)
    # Make sure brew path comes first so its executables are found before defaults.
    PATH="${BREW_PREFIX}/bin:${BREW_PREFIX}/sbin:${PATH}"
fi

### bash-completion ###
if [ -f "${BREW_PREFIX}/etc/bash_completion" ]; then
    # shellcheck disable=SC1090
    . "${BREW_PREFIX}/etc/bash_completion"
fi
