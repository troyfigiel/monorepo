{
  locale = import ./locale.nix;
  networking = import ./networking.nix;
  networkmanager = import ./networkmanager.nix;
  nix = import ./nix.nix;
  system = import ./system.nix;

  xorg = import ./desktop/xorg.nix;

  docker = import ./development/docker.nix;
  qemu-guest = import ./development/qemu-guest.nix;
  qemu = import ./development/qemu.nix;

  bluetooth = import ./hardware/bluetooth.nix;
  sound = import ./hardware/sound.nix;

  gpg = import ./security/gpg.nix;
  sops = import ./security/sops.nix;

  mail = import ./services/mail.nix;
  restic = import ./services/restic.nix;
  searx = import ./services/searx.nix;
  printing = import ./services/printing.nix;
  website = import ./services/website.nix;
}
