# -*- mode: shell-script -*-

source ~/.bash/aliases
source ~/.bash/prompt

### Basic config ###
export CLICOLOR=1
export EDITOR=/usr/bin/vi

# Use Sublime text if `subl` helper is installed.
if which subl > /dev/null; then
  export EDITOR='subl -n -w'
fi

### Homebrew stuff ###
HOMEBREW="$(which brew 2>/dev/null)"
if [ -n "$HOMEBREW" ] ; then
    # Make sure brew path comes first so its executables
    # are found before defaults.  Specifically helpful for
    # php and other things already provided by OSX.
    export PATH=`brew --prefix`/bin:`brew --prefix`/sbin:$PATH

    ### bash-completion ###
    if [ -f `brew --prefix`/etc/bash_completion ]; then
        . `brew --prefix`/etc/bash_completion
    fi

    ### rbenv ###
    if which rbenv > /dev/null; then
        export RBENV_ROOT=/usr/local/var/rbenv
        eval "$(rbenv init -)";
    fi
fi

### python ###
export PIP_RESPECT_VIRTUALENV=true
export PIP_REQUIRE_VIRTUALENV=true
export PYTHONDONTWRITEBYTECODE=true

# use .localrc for settings specific to one system
if [ -f ~/.localrc ]; then
  source ~/.localrc
fi

### Anything below this only applies to an interactive session.  ###
[[ $- = *i* ]] || return

# Handle resizes gracefully.
shopt -s checkwinsize
