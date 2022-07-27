#!/usr/bin/env bash
# This script installs the extensions that I was not able to install through Nix.
# These extensions need to be prepended with #TO INSTALL: .
# For example: #TO INSTALL: bbenoist.nix
while read -r line; do
	code --install-extension "$line"
done < <(sed --regexp-extended '/#TO INSTALL: /!d; s/\s+#TO INSTALL: //'  "./vscode.nix")
