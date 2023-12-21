clean:
	stow --delete --target ~/.config .

install: interactive brew configs
interactive:
	./interactive.sh
brew:
	./brew.sh
configs:
	stow --target ~/.config .
