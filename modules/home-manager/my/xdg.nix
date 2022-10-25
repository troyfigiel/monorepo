{ impermanence, config, lib, ... }:

with lib;
let cfg = config.my;
in {
  options.my.directories = mkOption {
    type = types.listOf (types.enum [
      "documents"
      "downloads"
      "audio"
      "pictures"
      "share"
      "videos"
      "projects"
    ]);
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
        userDirs = (mkMerge [
          {
            enable = true;
            createDirectories = false;

            desktop = homeDir;
            documents = setXDGUserDir "documents";
            download = setXDGUserDir "downloads";
            music = setXDGUserDir "audio";
            pictures = setXDGUserDir "pictures";
            publicShare = setXDGUserDir "share";
            templates = homeDir;
            videos = setXDGUserDir "videos";
          }

          (mkIf (elem "projects" cfg.directories) {
            extraConfig = { XDG_PROJECTS_DIR = "${homeDir}/projects"; };
          })
        ]);
      };
    }

    (optionalAttrs impermanence {
      home.persistence."/nix/persist/${homeDir}" = {
        directories = cfg.directories;
        allowOther = true;
      };
    })
  ]);
}
