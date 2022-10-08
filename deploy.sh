#!/run/current-system/sw/bin/env sh

echo "Just ran the deploy script!"
# This script should do the following:
# - Deploy my Terraform code and all my NixOS configurations to my servers.
# - Have the option to update the flake beforehand (deploy.sh --update).
# - Have an option --select hosts which only updates the machines in the hosts list.

# The Terraform code that should be deployed should be specific to the servers.
# Maybe we should not be deploying Terraform code relating to e.g. DNS records?

# TODO: Turn all of these options into short aliases.
