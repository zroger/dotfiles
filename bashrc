# -*- mode: shell-script -*-

### Basic config ###
export CLICOLOR=1
export EDITOR=$(which vim 2>/dev/null)

### Include modules from .bashrc.d
if [ -d ~/.bashrc.d ]; then
    for f in ~/.bashrc.d/*; do source $f; done
fi

### Add ruby gems user directory to path.
if which ruby >/dev/null && which gem >/dev/null; then
    export PATH="$(ruby -rubygems -e 'puts Gem.user_dir')/bin":$PATH
fi

# use .localrc for settings specific to one system
if [ -f ~/.localrc ]; then
  source ~/.localrc
fi

### Anything below this only applies to an interactive session.  ###
[[ $- = *i* ]] || return

# Handle resizes gracefully.
shopt -s checkwinsize
