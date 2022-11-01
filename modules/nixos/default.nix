{
  flake.nixosModules = {
    locale = import ./my/locale.nix;
    networking = import ./my/networking.nix;
    networkmanager = import ./my/networkmanager.nix;
    nix = import ./my/nix.nix;
    system = import ./my/system.nix;

    xorg = import ./my/desktop/xorg.nix;

    docker = import ./my/development/docker.nix;
    qemu-guest = import ./my/development/qemu-guest.nix;
    qemu = import ./my/development/qemu.nix;

    bluetooth = import ./my/hardware/bluetooth.nix;
    sound = import ./my/hardware/sound.nix;

    gpg = import ./my/security/gpg.nix;
    sops = import ./my/security/sops.nix;

    mail = import ./my/services/mail.nix;
    restic = import ./my/services/restic.nix;
    searx = import ./my/services/searx.nix;
    printing = import ./my/services/printing.nix;
    website = import ./my/services/website.nix;
  };
}
