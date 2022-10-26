{
  flake.nixosModules = {
    bluetooth = import ./my/bluetooth.nix;
    docker = import ./my/docker.nix;
    gpg = import ./my/gpg.nix;
    locale = import ./my/locale.nix;
    mail = import ./my/mail.nix;
    networking = import ./my/networking.nix;
    networkmanager = import ./my/networkmanager.nix;
    nix = import ./my/nix.nix;
    printing = import ./my/printing.nix;
    qemu-guest = import ./my/qemu-guest.nix;
    qemu = import ./my/qemu.nix;
    restic = import ./my/restic.nix;
    searx = import ./my/searx.nix;
    sops = import ./my/sops.nix;
    sound = import ./my/sound.nix;
    system = import ./my/system.nix;
    users = import ./my/users;
    website = import ./my/website.nix;
    xorg = import ./my/xorg.nix;
  };
}
