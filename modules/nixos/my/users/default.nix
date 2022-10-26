{ impermanence, config, lib, ... }:

with lib;
let cfg = config.my.users;
in {
  imports = [ ./home.nix ];
  options.my.users.enable = mkEnableOption "Test";
  config = mkIf cfg.enable {
    _module.args = let username = "troy"; in { inherit username; };
  };
}
