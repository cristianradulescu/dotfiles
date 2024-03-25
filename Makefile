# vim:ts=4
nvim-cleanup:
	rm -rf .config/nvim .cache}nvim .local/{share,state}/nvim

nvim-install-lazyvim:
	ln -s ~/dotfiles/.config/nvim-lazyvim ~/.config/nvim

nvim-install-kickstarter:
	ln -s ~/dotfiles/.config/nvim ~/.config/nvim

