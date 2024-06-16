all:
	darwin-rebuild switch --flake ".#AlessandroMBP"

repair:
	nix-collect-garbage -d
	sudo nix-store --verify --repair --check-contents
