{
  localModules = {
    sops = {
      enable = true;
      defaultSopsFile = ./secrets.yaml;
      sshPath = "/nix/persist/etc/ssh";
    };
    gpg.enable = true;
  };

  # TODO: By default the sudo password is the same password as my own password?
  # security.sudo = {
  #   enable = true;
  #   wheelNeedsPassword = true;
  #   execWheelOnly = true;
  # };
}
