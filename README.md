# NixOS configuration

## Getting started

- Need the GPG key on my Nitrokey card
- Unlock and import GPG key obtained from SSH host key

# Some notes

## Decoupling my configuration from my machine

My workflow on other distros has always been to manually change config files. This inevitably puts me in a position where I have to change a piece of software and I do not remember the specifics of its installation and configuration.

Nix circumvents this problem for me by creating the appropriate symlinks for me. This means that if some configuration does not work, I can rollback to a previous configuration without any pain.

## But grokking Nix is also difficult

The biggest downside to Nix is its learning curve: Not only do you need to know the Nix language, you also need to be familiar with the program you are configuring in case you need to debug your code.

In my opinion, the best way to figure out which options and configurations are possible, is by using the Nix REPL and reading the source code of nixpkgs.

# TODOs

Make this configuration less of a Frankenstein. In its current state it works for me, but I would not recommend it to anyone else.

Be aware, a lot of code has been copy-pasted and works for my specific case.

- bash
- gitconfig in projects/work
- copying Nix store
- VPN -> nework manager
- Set up a config for lazydocker and symlink it in place
- Set up browserpass
- Set up a Nix color scheme
- Add icons to Polybar
- Upgrade to a more recent version of the Linux kernel
- Save a predefined set of i3 window layouts
- The Nitrokey app icon should appear in the bottom bar upon startup
- Where are all my wallpapers stored?
- Change my cursor theme
- betterscreenlock automatically locks after 10 mins, even when a video is playing
- Set up impermance module. Can I use this together with Syncthing somehow?
- Look into Peerix
