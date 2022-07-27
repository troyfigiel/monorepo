{
  services.xserver = {
    enable = true;
    layout = "de";
    xkbVariant = "";

    videoDrivers = [ "modesetting" ];

    displayManager = {
      lightdm.enable = true;
      lightdm.greeters.pantheon.enable = true;
      #autoLogin.enable = true;
      #autoLogin.user = "troy";
    };

    desktopManager.pantheon.enable = true;

    libinput = {
      enable = true;
      touchpad.tapping = true;
    };
  };
}
