# NixOS configuration

# Some notes

- I rely on sops for Terraform as well. agenix might not be a good alternative to sops-nix in this case.
- sops-nix is designed to be scalable, but for safety precautions the secrets can only be unlocked per machine or with my master Nitrokey. Each machine I use serves a different purpose.

Unfortunately, I have not found that poetry2nix is 100% effective. It often happens that I am missing some module or library and I don't know how to add it. My current workflow is to use a Dockerfile, which also works but is not as reproducible.

## Copying Nix store

`nix copy --to 's3://nix-binary-cache?profile=minio&endpoint=192.168.178.37:10106&scheme=http' --all`

For Nix to be able to read from the binary cache, I will need to make sure the bucket is publicly readable.

What is the preferred way to clean up my binary cache? Is there a garbage control?

# TODOs

How cleanly separated are home-manager and NixOS? I should have a look by setting up a VM with e.g. Ubuntu and then installing home-manager and my home.

In the future it could be worthwhile to have a separate folder containing my .emacs.d. Right now it is part of my home, but if I want to use my Emacs config on a different machine that does not run NixOS or home-manager, I could still do it. Something to think about.

I should collect all possible sources of non-reproducibility in "features". These would be sets containing for example the org-roam directory location, whether I am persisting data, etc.

Learning more about Nix:
- Start using LUKS Disk Encryption
- Create my own iso

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
