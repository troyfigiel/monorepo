{ config, pkgs, ... }:

let inherit (config.home-manager.users.troy.home) homeDirectory;
in {
  home-manager.users.troy = {
    home.packages = with pkgs; [ signal-desktop tdesktop skypeforlinux ];

    home.persistence."/nix/persist/${homeDirectory}" = {
      directories = [
        # Signal stores its data in the .config directory.
        # See: https://github.com/signalapp/Signal-Desktop/issues/4975
        ".config/Signal"

        # Telegram has a single directory in .local/share
        ".local/share/TelegramDesktop"
      ];
      allowOther = true;
    };
  };
}
