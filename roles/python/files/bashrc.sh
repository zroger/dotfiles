# bash shell initialization for python

# pyenv
# ---
# I only use pyenv to install python versions, not for any of the shell
# integration, so only the PATH for shims is necessary.
export PYENV_ROOT="$HOME/.pyenv"
PATH="${PYENV_ROOT}/shims:${PATH}"
