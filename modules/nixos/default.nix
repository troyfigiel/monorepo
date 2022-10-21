{
  flake.nixosModules = {
    bluetooth = import ./bluetooth.nix;
    docker = import ./docker.nix;
    gpg = import ./gpg.nix;
    locale = import ./locale.nix;
    mail = import ./mail.nix;
    networking = import ./networking.nix;
    networkmanager = import ./networkmanager.nix;
    nix = import ./nix.nix;
    printing = import ./printing.nix;
    qemu-guest = import ./qemu-guest.nix;
    qemu = import ./qemu.nix;
    restic = import ./restic.nix;
    searx = import ./searx.nix;
    sops = import ./sops.nix;
    sound = import ./sound.nix;
    system = import ./system.nix;
    website = import ./website.nix;
    xorg = import ./xorg.nix;
  };
}
