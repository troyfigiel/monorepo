{ impermanence, config, lib, ... }:

with lib;
let cfg = config.my;
in {
  options.my.directories = mkOption {
    type = types.listOf (types.enum [
      "audio"
      "documents"
      "downloads"
      "misc"
      "pictures"
      "projects"
      "share"
      "videos"
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
        userDirs = mkMerge [
          {
            enable = true;
            createDirectories = false;

            desktop = homeDir;
            documents = setXDGUserDir "documents";
            download = setXDGUserDir "downloads";
            music = setXDGUserDir "audio";
            pictures = setXDGUserDir "pictures";
            templates = homeDir;
            videos = setXDGUserDir "videos";
          }

          (mkIf (elem "shared" cfg.directories) {
            publicShare = {
              device = "//nas/shared";
              fsType = "cifs";
              options = [
                "credentials=/nix/persist/etc/nixos/smb-secrets"
                "x-systemd.automount"
                "noauto"
                "uid=1000"
                "gid=100"
              ];
            };
          })

          (mkIf (elem "misc" cfg.directories) {
            extraConfig = { XDG_MISC_DIR = "${homeDir}/misc"; };
          })

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
