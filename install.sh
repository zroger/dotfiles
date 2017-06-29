#!/bin/bash -e

export DOTFILES
DOTFILES="$(dirname "$(readlink "${BASH_SOURCE[0]}")")"
# shellcheck source=install/utils.sh
source "${DOTFILES}/install/utils.sh"


mac_os && {
    header "homebrew packages"
    brew bundle install
}

linux && {
    header "linux stuff"
}

header "symlinks"
symlink bash/bashrc ~/.bashrc
symlink bash/bashrc.d ~/.bashrc.d
symlink psqlrc ~/.psqlrc
symlink tmux/tmux.conf ~/.tmux.conf

header "git"
symlink git/gitconfig ~/.gitconfig
symlink git/gitignore ~/.gitignore

header "vim"
symlink vim/vimrc ~/.vimrc
symlink vim/autoload/plug.vim ~/.vim/autoload/plug.vim
vim "+PlugInstall" "+qall"
