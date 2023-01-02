{ config, pkgs, ... }:

let inherit (config.home-manager.users.troy) home xdg;
in {
  imports = [ ./workstation.nix ];

  home-manager.users.troy = {
    home = {
      packages = with pkgs; [ signal-desktop tdesktop skypeforlinux ];

      persistence."/nix/persist${home.homeDirectory}" = {
        directories = [
          "${xdg.dataHome}/password-store"
          # Signal stores its data in the .config directory.
          # See: https://github.com/signalapp/Signal-Desktop/issues/4975
          ".config/Signal"

          # Telegram has a single directory in .local/share
          ".local/share/TelegramDesktop"
        ];
        allowOther = true;
      };
    };

    programs.password-store.enable = true;

    # TODO: This should be part of my workstation configuration, but on my VM picom does not seem
    # to work properly.
    services.picom = {
      enable = true;
      vSync = true;
    };
  };

  # virtualisation.libvirtd.enable = true;
  # environment = {
  #   systemPackages = with pkgs; [ qemu virt-manager ];
  #   persistence."/nix/persist".directories = [ "/var/lib/libvirt" ];
  # };
}
