{ config, ... }:

{
  xdg = let home = config.home.homeDirectory;
  in {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = false;

      desktop = home;
      documents = "${home}/documents";
      download = "${home}/downloads";
      music = home;
      pictures = home;
      publicShare = "${home}/share";
      templates = home;
      videos = home;

      extraConfig = { XDG_PROJECTS_DIR = "${home}/projects"; };
    };
  };

  home.persistence."/nix/persist/home/troy" = {
    directories = [
      "documents"
      "downloads"
      "projects"
    ];
    allowOther = true;
  };

}
