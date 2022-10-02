.PHONY: all home host
all:
	terraform -chdir=infrastructure apply -auto-approve
	nix run

home:
	home-manager switch --flake .

host:
	sudo nixos-rebuild switch --flake .
