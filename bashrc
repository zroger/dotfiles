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
    eval "$(pyenv init -)"
fi

for f in ~/.config/bashrc.d/*.sh; do
    source "$f"
done

# use .localrc for settings specific to one system
if [ -f ~/.localrc ]; then
  source ~/.localrc
fi

### Anything below this only applies to an interactive session.  ###
[[ $- = *i* ]] || return

# Handle resizes gracefully.
shopt -s checkwinsize


function random-word {
    gshuf -n1 ~/eff_short_wordlist_1.txt | awk '{print $2}'
}

function random-branch {
    echo $(random-word)-$(random-word)
}

if command -v go 1>/dev/null 2>&1 ; then
    PATH=$PATH:$(go env GOPATH)/bin
fi
