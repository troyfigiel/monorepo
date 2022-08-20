{
  imports = [ ./gpg.nix ./sops.nix ];

  # TODO: By default the sudo password is the same password as my own password?
  # security.sudo = {
  #   enable = true;
  #   wheelNeedsPassword = true;
  #   execWheelOnly = true;
  # };
}
