{ impermanence, config, lib, pkgs, ... }:

with lib;
let cfg = config.my.messenger;
in {
  options.my.messenger.enable = mkEnableOption "messenger";

  config = mkIf cfg.enable (mkMerge [
    {
      home.packages = with pkgs; [
        signal-desktop
        tdesktop
        whatsapp-for-linux
        skypeforlinux
      ];
    }

    (optionalAttrs impermanence {
      home.persistence."/nix/persist/${config.home.homeDirectory}" = {
        directories = [
          # Signal stores its data in the .config directory.
          # See: https://github.com/signalapp/Signal-Desktop/issues/4975
          ".config/Signal"

          ".config/whatsapp-for-linux"
          ".cache/whatsapp-for-linux"
          # webkitgtk also needs to be persisted to store WhatsApp data.
          # Unfortunately, this sometimes messes up and causes the app to be completely unusable.
          # The solution is simple: Move away from WhatsApp. It is bad software.
          # ".local/share/webkitgtk"

          # Telegram has a single directory in .local/share
          ".local/share/TelegramDesktop"
        ];
        allowOther = true;
      };
    })
  ]);
}
