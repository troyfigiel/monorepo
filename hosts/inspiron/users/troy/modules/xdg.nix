{ config, ... }:

{
  xdg = let home = config.home.homeDirectory;
  in {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;

      desktop = home;
      documents = "${home}/documents";
      download = "${home}/downloads";
      music = home;
      pictures = home;
      publicShare = home;
      templates = home;
      videos = home;

      extraConfig = { XDG_PROJECTS_DIR = "${home}/projects"; };
    };
  };
}
