all:
	darwin-rebuild switch --flake ".#AlexMBP"

repair:
	nix-collect-garbage -d
	sudo nix-store --verify --repair --check-contents
