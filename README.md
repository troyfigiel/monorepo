# NixOS configuration

## Getting started

- Need the GPG key on my Nitrokey card
- Need the SSH key from my /nix/persist/
- There is no need to store the SSH private key in secrets.yaml, since I persist it anyway.

# Some notes

The problems I am encountering with sops-nix do not have to do with:
- age vs gpg. If you create different key groups you need more than one key to unlock the file.
Previously I would add the pgp keys to the same keygroup, hence not encountering the problems.
- sops itself. I can decrypt and encrypt without issues.

This works:
- Import private ssh key as gpg key for root.
- Import public ssh key as gpg key for troy (needed to create the sops file and encrypt it to be readable by root).
- Encrypt in such a way that both me with my Nitrokey as well as root can read my secrets.

This requires:
- Persisting /etc/ssh
- Re-encrypting my secrets if I get a new computer

Hardware config can be updated by `nixos-generate-config --show-hardware-config > ...`

## Decoupling my configuration from my machine

My workflow on other distros has always been to manually change config files. This inevitably puts me in a position where I have to change a piece of software and I do not remember the specifics of its installation and configuration.

Nix circumvents this problem for me by creating the appropriate symlinks for me. This means that if some configuration does not work, I can rollback to a previous configuration without any pain.

## But grokking Nix is also difficult

The biggest downside to Nix is its learning curve: Not only do you need to know the Nix language, you also need to be familiar with the program you are configuring in case you need to debug your code.

In my opinion, the best way to figure out which options and configurations are possible, is by using the Nix REPL and reading the source code of nixpkgs.

# TODOs

Make this configuration less of a Frankenstein. In its current state it works for me, but I would not recommend it to anyone else.

Be aware, a lot of code has been copy-pasted and works for my specific case.

- Finish Bash config
- Symlink a gitconfig in projects/work so I do not accidentally commit with the wrong email
- Use NetworkManager to manager my VPN connections
- Set up browserpass
- Set up a Nix color scheme
- Add icons to Polybar
- Save a predefined set of i3 window layouts
- The Nitrokey app icon should appear in the bottom bar upon startup
- Change my cursor theme
- betterscreenlock automatically locks after 10 mins, even when a video is playing
- Set up impermance module. Can I use this together with Syncthing somehow?
- copying Nix store / Look into Peerix / Cachix
- Automatically import public keys into /home/troy/.gnupg with ultimate trust
