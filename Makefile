clean:
	stow --delete --target ~/.config .

install: brew configs
brew:
	./brew.sh
configs:
	stow --target ~/.config .
