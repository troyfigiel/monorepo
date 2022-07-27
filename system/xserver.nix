{ pkgs, ... }:

{
  services.xserver = {
    enable = true;
    layout = "de";
    xkbVariant = "";
    videoDrivers = [ "modesetting" ];
    displayManager = {
      lightdm.enable = true;
      defaultSession = "none+i3";
    };
    desktopManager = {
      xterm.enable = false;
      xfce = {
        enable = true;
        noDesktop = true;
        enableXfwm = false;
      };
    };
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [ rofi polybar i3lock ];
    };
    libinput = {
      enable = true;
      touchpad.tapping = true;
    };
  };
}
