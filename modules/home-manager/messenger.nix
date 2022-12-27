{ impermanence, config, lib, pkgs, ... }:

with lib;
let cfg = config.my.messenger;
in {
  options.my.messenger.enable = mkEnableOption "messenger";

  config = mkIf cfg.enable (mkMerge [
    { home.packages = with pkgs; [ signal-desktop tdesktop skypeforlinux ]; }

    (optionalAttrs impermanence {
      home.persistence."/nix/persist/${config.home.homeDirectory}" = {
        directories = [
          # Signal stores its data in the .config directory.
          # See: https://github.com/signalapp/Signal-Desktop/issues/4975
          ".config/Signal"

          # Telegram has a single directory in .local/share
          ".local/share/TelegramDesktop"
        ];
        allowOther = true;
      };
    })
  ]);
}
