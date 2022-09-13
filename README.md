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

## Copying Nix store

`nix copy --to 's3://nix-binary-cache?profile=minio&endpoint=192.168.178.37:10106&scheme=http' --all`

For Nix to be able to read from the binary cache, I will need to make sure the bucket is publicly readable.

What is the preferred way to clean up my binary cache? Is there a garbage control?

## Decoupling my configuration from my machine

My workflow on other distros has always been to manually change config files. This inevitably puts me in a position where I have to change a piece of software and I do not remember the specifics of its installation and configuration.

Nix circumvents this problem by creating the appropriate symlinks for me. This means that if some configuration does not work, I can rollback to a previous configuration without any pain.

## But grokking Nix is also difficult

The biggest downside to Nix is its learning curve: Not only do you need to know the Nix language, you also need to be familiar with the program you are configuring in case you need to debug your code.

In my opinion, the best way to figure out which options and configurations are possible, is by using the Nix REPL and reading the source code of nixpkgs.

## Hermetic sealing

Because Nix is so strict on reproducibility and hermetically sealing your environment, you end up having to bring dependencies close together.

For example, if I want to add a blog and create that as a separate repository, that is not going to work nicely. If I update the blog I expect the changes to be visible instanteneously, but this will not happen with Nix since it will pull in a specific git revision and not the latest.

I am not sure if there is a nice solution to this problem while maintaining my blog in a separate repository.

I can think of either:
- I trigger a nixos-config pipeline from a blog pipeline to rebuild my website and update it.
- I treat the website as state on my server, but then there is no guarantee I get exactly what I want.

Overall, I would say, Nix does a great job keeping all of the related code in a single repository. Dependencies between Nix flakes will be loosely coupled by design.

# TODOs

Unfortunately, I have not found that poetry2nix is 100% effective. It often happens that I am missing some module or library and I don't know how to add it. My current workflow is to use a Dockerfile, which also works but is not as reproducible.

I am currently using home-manager as a NixOS module, but I would also like to be able to use home-manager on non-NixOS. This means I will need to separate out my home-manager config.

I keep on running into infinite recursion errors when I try to add modules. This is currently what is blocking me from adding the emacs-init home-manager module. Why is this happening?

It would make sense to start splitting my large flake.nix into multiple smaller ones. Flakes for my hosts, for my homes, etc.

Learning more about Nix:
- Start using LUKS Disk Encryption
- Create my own iso
- Is it possible to use persistence as a home-manager module as well? What would be the nicest way to move my persisted user directories to the appropriate modules?

Setting up the right configuration:
- Use headphones to start and pause videos / music
- Receive a notification when the battery is low (at 20% and at 10%). That should be easy with Dunst.
- Set up a nice notification theme for increasing / decreasing brightness and volume
- Set up browserpass. Or can I use rofi-pass for that?
- Set up a consistent Nix color scheme using nix-colors
- Add icons to Polybar
- Save a predefined set of i3 window layouts
- The Nitrokey app icon should appear in the bottom bar upon startup
- Change my cursor theme
- betterscreenlock automatically locks after 10 mins, even when a video is playing
- Can I use the impermanence module together with Syncthing somehow?

To be added to polybar / dunst:
- Volume
- Brightness
- Music player
- Bluetooth
- Networks
- VPN
- Active window (i3)
- Temperature
- Hard disk drive remaining and tmpfs size remaining
