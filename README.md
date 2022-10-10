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

**Important**
Currently I have a single lock file. If I update this lock file, I might end up breaking a configuration that I do not immediately test with my deploy. Instead I should have a flake and a lock file in each module (each host, each home, etc.) and a main flake file which triggers my deploys from the root of the repository. This does make updates more complicated, because I will have to update all flakes simultaneously, but this can be easily fixed by using a Makefile.

More notes:
2. I want a given host to have a lock file that I am sure works. I do not want to be in a situation where I have updated my lockfile but did not check a certain host and now some packages broke. Instead, I would prefer to let Nix do automatic updates.
4. This means I do not need to deploy homes separately and I do not need to use deploy-rs necessarily. Maybe I could use terraform-nixos or something like morph?
5. I would have different flakes for each host, each virtual machine, infrastructure, website / org, my overlay
6. I should start by creating flakes for my website and overlay which have an overlay output.
7. If I have so many flakes, I will need to simplify the update process. The best would be to create a simple deploy script that helps me out. The Makefile calls the deploy script, but can also be used for building iso files for example. Maybe Make is still nice? It can easily parallellize the deploy steps, is kind of declarative and well-known.
8. For the website, I should probably end up with a blog of more introductory articles and then have a separate series that goes into more detail.
9. I should keep the host names short, i.e. to a single word: cloud-server -> cloud, virtual-devbox -> devbox.

Cleanly separate the different parts of my home configuration. Picom, i3, polybar, etc. all belong under the overarching desktop setup, whereas syncthing or vscode fall under a different umbrella.

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

## flakes
- Use separate flakes, but have a shared flake-module.nix in hosts that imports lib
- Keep flakes DRY by importing flake modules with flake-parts

## templates
- Add a host template which sets up a basic host config with flake and all

## hosts
- Rename to nixos if I am only going to be running NixOS
- Development is done on virtual machines, no standalone home-manager is needed

## modules & lib
- Create them at the root of the monorepo

### modules
- I can create modules and enable them to specify exactly which config is used by which host
  - This is cleaner than importing, because it also allows me to set any variables I need to
  - The Nix code for each host will be fairly small. Just setting which config to enable.
- Since these are kind of "meta-modules" that are only useful to keep my code DRY, it is best to keep the number of options as small as possible.
  - If a configuration does not vary between hosts, do not add it as an option
  - The exception is the "enable" option which allows me to easily add or delete configurations, plus it is standard in nixpkgs as well.
- Because these modules are "meta-modules", I might want to rename them to distinguish them from the modules that I might need to create myself
  - Profiles might be a good naming?

### lib
- To extend the default lib from nixpkgs, I can use lib.extend and supply an overlay

## website
- Blogs and articles should be different
  - Blogs are more opinion-based and "life lessons"
  - Articles contain more clear-cut information and can often span series
- Instead of using a git commit hash, I could use the derivation Nix returns
  - This has the advantage that I could even save all the previous versions of my website in my own cache and let people request them as needed
- Clarify that the website is a work in progress and there is no guarantee for correctness or representability of myself at this point in time

## tfmacs
- I should create a home-manager module out of my config
- tfmacs should be a separate directory with all of my Emacs config
- README.org at the base of tfmacs explaining how I am using my Emacs config together with Nix
- settings.el at the base of tfmacs which reads environment variables and turns this into a modular Emacs config (e.g. if ORG_ROAM_DIRECTORY is not set, do not load org-roam)
- Packages required by Nix should be read from a simple epkgs.txt file

## packages
- Rename pkgs to packages
- Add a flake.nix that outputs an overlay? Not so sure yet how to handle my own packages.

## Lutris on Nix?
- How does it work? How many Windows-only games are included?

## README
- Turn this README into an org file
- Clean up this README
- Clarify that this repo is a work in progress and only intended for me

## deploy
- Create my own basic command line tool to handle multiple flakes in this monorepo?
- deploy should have update and upgrade options

## License
- Add license if I continue developing, but I am not sure which one is legally allowed... If there is any Emacs code in there, it should be GPL?

## features
- Some cross-cutting concerns exist that cannot be fixed through the module structure. For example, whether we are persisting data or not
- Similarly, sops and all the security settings are cross-cutting
- Sometimes the choice of desktop (like gnome) also defines certain functionality. For example, Gnome automatically sets its own keyring.
- This is reminiscent of aspect-oriented programming. We might want to call the options such as whether a machine is using persistence aspects instead of features.
- The type of hardware I have (bluetooth, sound, wifi, etc.) could also be cross-cutting
