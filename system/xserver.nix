{
  services.xserver = {
    enable = true;
    layout = "de";
    xkbVariant = "";

    videoDrivers = [ "modesetting" ];

    displayManager = {
      lightdm.enable = true;
      lightdm.greeters.pantheon.enable = true;
    };

    desktopManager.pantheon.enable = true;

    libinput = {
      enable = true;
      touchpad.tapping = true;
    };
  };
}
