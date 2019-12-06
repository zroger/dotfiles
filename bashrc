# -*- mode: shell-script -*-

#__DOTFILES_DEBUG=1

__log() {
    if [ ! -z "${__DOTFILES_DEBUG}" ]; then
        echo "[DEBUG] ${1} (${SECONDS} seconds)"
    fi
}

__log "Entered .bashrc"

### Basic config ###
export CLICOLOR=1
export EDITOR=$(which vim 2>/dev/null)

export DOTFILES
DOTFILES="$(dirname "$(dirname "$(readlink "${HOME}/.bashrc")")")"

export PATH

### python ###
export PIP_RESPECT_VIRTUALENV=true
export PYTHONDONTWRITEBYTECODE=true
export VIRTUAL_ENV_DISABLE_PROMPT=1

# `pip install --user` installs to ~/.local
if [[ -d ~/.local/bin ]]; then
    export PATH="~/.local/bin:${PATH}"
fi

if [ -n "$(which pyenv 2>/dev/null)" ] ; then
    __log "pyenv init"
    eval "$(pyenv init -)"
fi

if [[ -x /usr/local/bin/hub ]]; then
    alias git=hub
fi

# use .localrc for settings specific to one system
if [ -f ~/.localrc ]; then
  __log ".localrc"
  source ~/.localrc
fi

### Anything below this only applies to an interactive session.  ###
[[ $- = *i* ]] || return

[[ -n "$ITERM2_PROFILE" ]] && {
    iterm2_set_profile() {
        local profile="$1"
        printf "\x1B]1337;SetProfile=${profile}\x07"
        ITERM_PROFILE="$profile"
    }


    bg_light() {
        iterm2_set_profile "Light"
        clear
    }

    bg_dark() {
        iterm2_set_profile "Dark"
        clear
    }
}

# Handle resizes gracefully.
shopt -s checkwinsize


function random-word {
    gshuf -n1 ~/eff_short_wordlist_1.txt | awk '{print $2}'
}

function random-branch {
    echo $(random-word)-$(random-word)
}

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

PATH=$PATH:$(go env GOPATH)/bin
