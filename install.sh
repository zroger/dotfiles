#!/bin/bash -e

export DOTFILES
DOTFILES="$(dirname "${BASH_SOURCE[0]}")"
# shellcheck source=lib/installer.sh
source "${DOTFILES}/lib/installer.sh"


mac_os && {
    header "macos stuff"
    homebrew
    brew bundle install --file="${DOTFILES}/macos/Brewfile"
}

linux && {
    header "linux stuff"
    linuxbrew
    brew bundle install --file="${DOTFILES}/linux/Brewfile"
}

header "symlinks"
symlink bash_profile ~/.bash_profile
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
