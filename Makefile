# vim:foldmethod=marker:foldlevel=0:tabstop=4

# Environment variable defaults
XDG_CONFIG_HOME ?= $(HOME)/.config

.DEFAULT_GOAL := install
.PHONY : install

install : install-bash install-powerline install-vim install-tmux

install-bash :
	rm -rfv ~/.bashrc ~/.bashrc.d
	ln -s $(realpath bash/bashrc) ~/.bashrc
	ln -s $(realpath bash/bashrc.d) ~/.bashrc.d

install-powerline :
	mkdir -p $(XDG_CONFIG_HOME)
	rm -rfv $(XDG_CONFIG_HOME)/powerline
	ln -s $(realpath powerline) $(XDG_CONFIG_HOME)/powerline
	powerline-daemon --replace

install-vim :
	rm -fv ~/.vimrc ~/.vim/autoload/plug.vim
	ln -s $(realpath vim/vimrc) ~/.vimrc
	mkdir -p ~/.vim/autoload/
	ln -s $(realpath vim/autoload/plug.vim) ~/.vim/autoload/plug.vim
	vim "+PlugInstall" "+qall"

install-tmux:
	rm -fv ~/.tmux.conf
	ln -s $(realpath tmux/tmux.conf) ~/.tmux.conf
