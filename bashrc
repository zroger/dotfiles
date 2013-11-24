# -*- mode: shell-script -*-

source ~/.bash/aliases

### Basic config ###
export CLICOLOR=1
export EDITOR=$(which vim 2>/dev/null)

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

    if [ -f `brew --prefix autoenv`/activate.sh ]; then
        . `brew --prefix autoenv`/activate.sh
    fi
fi

if [[ -f /etc/bash_completion ]]; then
    . /etc/bash_completion
fi

# `pip install --user` installs to ~/.local
if [[ -d ~/.local/bin ]]; then
    export PATH=$PATH:~/.local/bin
fi

### python ###
export PIP_RESPECT_VIRTUALENV=true
# export PIP_REQUIRE_VIRTUALENV=true
export PYTHONDONTWRITEBYTECODE=true
export VIRTUAL_ENV_DISABLE_PROMPT=1

if [ -f ~/.local/bin/virtualenvwrapper.sh ]; then
    mkdir -p ~/Envs
    export WORKON_HOME=~/Envs
    source ~/.local/bin/virtualenvwrapper.sh

    (workon | grep -e '^default$' > /dev/null) || mkvirtualenv default
    workon default

else
    echo "### virtualenvwrapper not found ###"
fi

# Use bash powerline prompt if available; fallback to old prompt otherwise
POWERLINE_COMMAND=$VIRTUAL_ENV/bin/powerline
BASH_POWERLINE=$VIRTUAL_ENV/lib/python2.7/site-packages/powerline/bindings/bash/powerline.sh
if [ -f $BASH_POWERLINE ]; then
    source $BASH_POWERLINE

    # Override _powerline_prompt to invoke powerline twice for a 2 line prompt.
    _powerline_prompt() {
        local last_exit_code=$?
        [[ -z "$POWERLINE_OLD_PROMPT_COMMAND" ]] ||
                eval $POWERLINE_OLD_PROMPT_COMMAND

        PS1="\n"
        PS1="$PS1$($POWERLINE_COMMAND shell left -r bash_prompt --last_exit_code=$last_exit_code)"
        PS1="$PS1\n"
        PS1="$PS1$($POWERLINE_COMMAND shell2 left -r bash_prompt --last_exit_code=$last_exit_code)"
        _powerline_tmux_set_pwd
        return $last_exit_code
}

else
    source ~/.bash/prompt
fi



# use .localrc for settings specific to one system
if [ -f ~/.localrc ]; then
  source ~/.localrc
fi

### Anything below this only applies to an interactive session.  ###
[[ $- = *i* ]] || return

# Handle resizes gracefully.
shopt -s checkwinsize
