{ pkgs, ... }:

{
  imports = [
    ./impermanence.nix
    ./locale.nix
    ./sound.nix
    ./xorg.nix
  ];

  # This is approximately how I should do an auto-upgrade, but the code here
  # probably does not work as-is.

  # system.autoUpgrade = {
  #   enable = true;
  #   allowReboot = true;
  #   # What is self.outPath?
  #   flake = self.outPath;
  #   # These are the flags going into nixos-rebuild
  #   flags = [
  #     "--recreate-lock-file"
  #     "--no-write-lock-file"
  #     "-L" # print build logs
  #   ];
  #   dates = "daily";
  #   # I might want to change the rebootWindow parameters.
  # };

  system.stateVersion = "22.05";

  # TODO: I have to move the packages to the respective modules that use them.
  environment.systemPackages = with pkgs;
    # TODO: Can I make this into an overlay instead?
    let sddm-sugar-candy = callPackage ../../../pkgs/sddm-sugar-candy { };
    in [
      sddm-sugar-candy

      # TODO: This should be moved to the sddm package instead
      # Dependencies for sddm-sugar-candy
      libsForQt5.qt5.qtgraphicaleffects
      libsForQt5.qt5.qtquickcontrols2
      libsForQt5.qt5.qtsvg

      # Others
      nix-index
      git

      # bpytop
      python3
      # sqlite

      inxi

      vim
      # w3m
      wget
      # xclip
      nixfmt
      # qemu

      # For i3 sshfs
      # mpc-cli
      brightnessctl

      # Nicer form of du
      # ncdu
    ];

  # TODO: Is there a way to set this up with home-manager? Not system-wide
  # TODO: How do I use Proton in Nix?
  programs.steam.enable = true;

  virtualisation.docker.enable = true;
}
