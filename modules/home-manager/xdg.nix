{ impermanence, config, lib, ... }:

with lib;
let cfg = config.my;
in {
  options.my.directories = mkOption {
    type = types.listOf (types.enum [ "documents" "downloads" "projects" ]);
    default = [ ];
    description = "Directories to enable.";
  };

  config = let homeDir = config.home.homeDirectory;
  in mkIf (cfg.directories != [ ]) (mkMerge [
    {
      xdg = let
        setXDGUserDir = dir:
          if elem dir cfg.directories then "${homeDir}/${dir}" else homeDir;
      in {
        enable = true;
        userDirs = mkMerge [
          {
            enable = true;
            createDirectories = false;

            desktop = homeDir;
            documents = setXDGUserDir "documents";
            download = setXDGUserDir "downloads";
            music = homeDir;
            pictures = homeDir;
            publicShare = homeDir;
            templates = homeDir;
            videos = homeDir;
          }

          (mkIf (elem "projects" cfg.directories) {
            extraConfig = { XDG_PROJECTS_DIR = "${homeDir}/projects"; };
          })
        ];
      };
    }

    (optionalAttrs impermanence {
      home.persistence."/nix/persist/${homeDir}" = {
        inherit (cfg) directories;
        allowOther = true;
      };
    })
  ]);
}
