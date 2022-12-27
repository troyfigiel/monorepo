{ config, ... }:

let inherit (config.home-manager.users.troy.home) homeDirectory;
in {
  home-manager.users.troy = {
    xdg = {
      enable = true;
      userDirs = {
        enable = true;
        createDirectories = false;

        desktop = homeDirectory;
        documents = "${homeDirectory}/documents";
        download = "${homeDirectory}/downloads";
        music = homeDirectory;
        pictures = homeDirectory;
        publicShare = homeDirectory;
        templates = homeDirectory;
        videos = homeDirectory;
        extraConfig = { XDG_PROJECTS_DIR = "${homeDirectory}/projects"; };
      };
    };

    home.persistence."/nix/persist${homeDirectory}" = {
      directories = [ "documents" "downloads" "projects" ];
      allowOther = true;
    };
  };
}
