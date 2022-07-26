{
  services.xserver = {
    enable = true;
    layout = "de";
    xkbVariant = "";

    videoDrivers = [ "modesetting" ];

    displayManager = {
      lightdm.enable = true;
      autoLogin.enable = true;
      autoLogin.user = "troy";
    };
    desktopManager.cinnamon.enable = true;

    libinput = {
      enable = true;
      touchpad.tapping = true;
    };
  };
}
