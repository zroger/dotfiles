# vim:foldmethod=marker:foldlevel=0

.PHONY: install clean bash powerline
.DEFAULT_GOAL := install

$(HOME)/.config :
	mkdir -p $(HOME)/.config

# bash config files {{{
bash: $(HOME)/.bashrc $(HOME)/.bashrc.d

$(HOME)/.bashrc :
	ln -s $(CURDIR)/bashrc $@

$(HOME)/.bashrc.d :
	ln -s $(CURDIR)/bashrc.d $@
# }}}

# powerline config files {{{
powerline : $(HOME)/.config/powerline

$(HOME)/.config/powerline : $(HOME)/.config
	ln -s $(CURDIR)/.config/powerline $@
# }}}

install : bash powerline

clean:
	rm $(HOME)/.bashrc
	rm $(HOME)/.bashrc.d
	rm $(HOME)/.config/powerline
