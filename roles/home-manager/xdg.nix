{ impermanence, config, lib, ... }:

with lib;
let cfg = config.roles.xdg;
in {
  options.roles.xdg = {
    enable = mkEnableOption "xdg";
    # directories = mkOption {
    #   type = types.listOf types.str;
    #   description = ''
    #     Which directories to activate
    #   '';
    # };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      xdg = {
        enable = true;
        userDirs = {
          enable = true;
          createDirectories = false;

          desktop = config.home.homeDirectory;
          documents = "${config.home.homeDirectory}/documents";
          download = "${config.home.homeDirectory}/downloads";
          music = config.home.homeDirectory;
          pictures = config.home.homeDirectory;
          publicShare = "${config.home.homeDirectory}/share";
          templates = config.home.homeDirectory;
          videos = config.home.homeDirectory;

          extraConfig = {
            XDG_PROJECTS_DIR = "${config.home.homeDirectory}/projects";
          };
        };
      };
    }

    (optionalAttrs impermanence {
      home.persistence."/nix/persist/${config.home.homeDirectory}" = {
        directories = [ "documents" "downloads" "projects" ];
        allowOther = true;
      };
    })
  ]);
}
