{ impermanence, config, lib, ... }:

with lib;
let cfg = config.roles.docker;
in {
  options.roles.docker.enable = mkEnableOption "Docker";

  config = mkIf cfg.enable (mkMerge [
    { virtualisation.docker.enable = true; }

    (optionalAttrs impermanence {
      environment.persistence."/nix/persist".directories =
        [ "/var/lib/docker" ];
    })
  ]);
}
