{ pkgs, ... }:

{
  imports = [ ./.. ];

  services.qemuGuest.enable = true;
  # TODO: For some reason it does not seem to rescale the screen for UTM on MacOS. Why?
  services.spice-vdagentd.enable = true;

  services.xserver = {
    # TODO: Only some applications seem to scale when I set dpi. Should I use a different setting?
    # dpi = 60;

    # Unfortunately, this seems to be necessary for UTM. I have not managed to get spice-vdagentd to work properly.
    displayManager.sessionCommands =
      "${pkgs.xorg.xrandr}/bin/xrandr -s 1920x1200";

    # TODO: modesetting is necessary to even get i3 to run successfully. Otherwise no screens will be found. What does this do?
    # Modesetting fixed the issues I had with sddm and i3.
    # I do have some issues with the compositor still.
    videoDrivers = [ "modesetting" "qxl" ];
  };

  users.users.troy.initialPassword = "nixos";

  system.stateVersion = "22.11";
}
