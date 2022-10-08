.PHONY: all update build
all:
	terraform -chdir=infrastructure apply -auto-approve
	deploy

update:
	echo "Updating flake for current machine."

build:
	echo "Building NixOS configuration for current machine."

deploy:
	echo "Deploying to all servers."

# TODO: I should use the syntax `make update HOST=...` to specify a host. Update should default to the current host.
# TODO: The same but with deploy: `make deploy HOST=...` to specify a host. Deploy should default to all hosts.
# This might all be better as a simple deployment script? I do not actually need the complexity of Make.