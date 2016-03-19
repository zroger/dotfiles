# vim:foldmethod=marker:foldlevel=0:tabstop=4

# Environment variable defaults
XDG_CONFIG_HOME ?= $(HOME)/.config

.DEFAULT_GOAL := install
.PHONY : install

install : install-bash install-powerline install-vim

install-bash :
	rm -rfv ~/.bashrc ~/.bashrc.d
	ln -s $(CURDIR)/bashrc ~/.bashrc
	ln -s $(CURDIR)/bashrc ~/.bashrc.d

install-powerline :
	mkdir -p $(XDG_CONFIG_HOME)
	rm -rfv $(XDG_CONFIG_HOME)/powerline
	ln -s $(CURDIR)/config/powerline $(XDG_CONFIG_HOME)/powerline

install-vim :
	rm -fv ~/.vimrc ~/.vim/autoload/plug.vim
	ln -s $(CURDIR)/vimrc ~/.vimrc
	mkdir -p ~/.vim/autoload/
	ln -s $(CURDIR)/vim/autoload/plug.vim ~/.vim/autoload/plug.vim
	vim "+PlugInstall" "+qall"
