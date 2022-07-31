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

    windowManager = {
      xmonad = {
        enable = false;
        enableContribAndExtras = false;
        extraPackages = hp: [
          hp.xmobar
          hp.xmonad-screenshot
        ];
      };
    };

    desktopManager.pantheon.enable = true;

    libinput = {
      enable = true;
      touchpad.tapping = true;
    };
  };
}
