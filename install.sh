#!/bin/bash -e

export DOTFILES
DOTFILES="$(dirname "${BASH_SOURCE[0]}")"


[[ "$(uname -s)" == "Darwin" ]] && {
    BREW="/usr/local/bin/brew"
    [ -x "$BREW" ] || {
        echo "==> Installing homebrew for mac"
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    }
}

[[ "$(uname -s)" == "Linux" ]] && {
    BREW="$HOME/.linuxbrew/bin/brew"
    [ -x "$BREW" ] || {
        echo "==> Installing linuxbrew"
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
    }
}

$BREW list ansible > /dev/null || {
    echo "==> Installing ansible via homebrew"
    $BREW install ansible
}

# TODO: linuxbrew
ANSIBLE_PLAYBOOK="$($BREW --prefix ansible)/bin/ansible-playbook"

"${ANSIBLE_PLAYBOOK}" -c local -i localhost, "${DOTFILES}/playbook.yml"
