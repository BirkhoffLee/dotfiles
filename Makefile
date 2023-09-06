all:
	darwin-rebuild switch --flake ".#BirkhoffMBPR14" --fallback

repair:
	nix-collect-garbage -d
	sudo nix-store --verify --repair --check-contents
