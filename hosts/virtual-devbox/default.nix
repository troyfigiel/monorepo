{ inputs, pkgs, ... }:

{
  imports = [
    ../shared/docker.nix
    ../shared/dunst.nix
    ../shared/emacs.nix
    ../shared/git.nix
    ../shared/home.nix
    ../shared/i3.nix
    ../shared/locale.nix
    ../shared/nix.nix
    # ../shared/picom.nix
    ../shared/qemu-guest.nix
    ../shared/rofi.nix
    ../shared/system.nix
    ../shared/xdg.nix
    ../shared/xorg.nix
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  services.xserver = {
    # TODO: Only some applications seem to scale when I set dpi. Should I use a different setting?
    # dpi = 60;

    # Unfortunately, this seems to be necessary for UTM. I have not managed to get spice-vdagentd to work properly.
    displayManager.sessionCommands =
      "${pkgs.xorg.xrandr}/bin/xrandr -s 1920x1200";

    # TODO: modesetting is necessary to even get i3 to run successfully. Otherwise no screens will be found. What does this do?
    # Modesetting fixed the issues I had with sddm and i3.
    # I do have some issues with the compositor still.
    videoDrivers = [ "modesetting" "qxl" ];
  };

  users.users.troy = {
    initialPassword = "nixos";
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    packages = with pkgs; [ git gnumake vim ];
  };

  programs.fuse.userAllowOther = true;

  system.stateVersion = "22.11";
}
