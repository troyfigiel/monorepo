{
  flake = {
    hmFeatures = {
      alacritty = import ./alacritty.nix;
      background = import ./background.nix;
      dunst = import ./dunst.nix;
      emacs = import ./emacs;
      firefox = import ./firefox.nix;
      git = import ./git.nix;
      gpg = import ./gpg.nix;
      i3 = import ./i3.nix;
      messenger = import ./messenger.nix;
      nvim = import ./nvim.nix;
      pass = import ./pass.nix;
      picom = import ./picom.nix;
      polybar = import ./polybar.nix;
      rofi = import ./rofi;
      syncthing = import ./syncthing.nix;
      vscode = import ./vscode.nix;
      xdg = import ./xdg.nix;
      zsh = import ./zsh;
    };

    nixosFeatures = {
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

    terranixFeatures = { };
  };
}
