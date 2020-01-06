#!/bin/bash

DOTFILES=$(git -C "$(dirname $0)" rev-parse --show-toplevel)

# ---
# Create a symlink from the dotfiles to the home directory.
#
# Usage:
#   link target [...] dest
#
# One or more `target` are supported. Each will be prepended with the
# DOTFILES path, to create absolute symbolic links.
#
# `dest` is the path to create the symbolic link. It will be prepended
# with the home directory. If dest has a trailing slash, it is
# considered to be a directory path, and the directory will be created
# before adding links to it. Otherwise, it is considered a file path,
# and the parent directory will be created before creating the symlink.
# ---
function link() {
    local targets="${*::$#}"
    local dest="${HOME}/${*:$#}"

    if [[ "$dest" == */ ]]
    then
        dest="${dest%/}"
        mkdir -p "$dest"
    else
        mkdir -p "$(dirname "$dest")"
    fi

    for target in $targets
    do
        ln -svf "${DOTFILES}/${target}" "$dest"
    done
}


# bash
# --------------------------------------
link bash/bash_profile .bash_profile
link bash/bashrc .bashrc
link bash/bashrc.d/*.sh .config/bash/bashrc.d/


# gnupg
# --------------------------------------
link gnupg/gpg.conf .gnupg/
link gnupg/gpg-agent.conf .gnupg/
link gnupg/bashrc.sh .config/bash/bashrc.d/gnupg.sh

# Limit permissions to just the current user.
chmod -R go-rwx "${HOME}/.gnupg"


# ssh
# --------------------------------------
link ssh/config .ssh/
link ssh/config.d/* .ssh/config.d/

# Limit permissions to just the current user.
chmod -R go-rwx "${HOME}/.gnupg"


# git
# --------------------------------------
link git/config .config/git/
link git/ignore .config/git/
link git/template/hooks/* .config/git/template/hooks/


# vim
# --------------------------------------
link vim/vimrc .vim/
link vim/colors/*.vim .vim/colors/
link vim/editorconfig .editorconfig


# tmux
# --------------------------------------
link tmux/tmux.conf .tmux.conf
link tmux/vim-tmux-navigator.conf .config/tmux/
link tmux/is_vim.sh .config/tmux/
