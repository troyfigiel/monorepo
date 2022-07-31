{
  users.users.troy = {
    isNormalUser = true;
    home = "/home/troy"; # TODO: Is this not the default home?
    description = "Troy Figiel";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    # TODO: How can I set this? Do I need initialPassword or is passwordFile enough?
    # passwordFile = ...
  };
}
