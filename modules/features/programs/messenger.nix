{ impermanence, config, lib, pkgs, ... }:

with lib;
let cfg = config.features.messenger;
in {
  options.features.messenger.enable = mkEnableOption "messenger";

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
        ];
        allowOther = true;
      };
    })
  ]);
}
