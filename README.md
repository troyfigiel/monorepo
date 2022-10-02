# NixOS configuration

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
- Persisting /etc/ssh/
- Re-encrypting my secrets if I get a new computer

Hardware config can be updated by `nixos-generate-config --show-hardware-config > ...`

- I rely on sops for Terraform as well. agenix might not be a good alternative to sops-nix in this case.
- sops-nix is designed to be scalable, but for safety precautions the secrets can only be unlocked per machine or with my master Nitrokey. Each machine I use serves a different purpose.

- I can sync my persistent home files using Syncthing. I should not run Syncthing as root. The remaining persisted files and directories should be backed up with restic. There are fewer of them anyway and they are probably machine specific.
- For extra precautions, I can decide to run Syncthing only in my local network.
- I should run Syncthing as a home-manager service, not NixOS module. The home-manager service also has a tray option.
- Should I make my /nix/persist a zfs file system? Then I can do roll-backs just as I would for Nix but on my data. Might be nice? Create a snapshot on boot.

This requires first using impermanence as a home-manager module and moving over my persisted home directories and files to that module instead.

## Copying Nix store

`nix copy --to 's3://nix-binary-cache?profile=minio&endpoint=192.168.178.37:10106&scheme=http' --all`

For Nix to be able to read from the binary cache, I will need to make sure the bucket is publicly readable.

What is the preferred way to clean up my binary cache? Is there a garbage control?

# TODOs

Unfortunately, I have not found that poetry2nix is 100% effective. It often happens that I am missing some module or library and I don't know how to add it. My current workflow is to use a Dockerfile, which also works but is not as reproducible.

How cleanly separated are home-manager and NixOS? I should have a look by setting up a VM with e.g. Ubuntu and then installing home-manager and my home.

I should collect all possible sources of non-reproducibility in "features". These would be sets containing for example the org-roam directory location, whether I am persisting data, etc.

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
