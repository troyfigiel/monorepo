{ impermanence, config, lib, ... }:

with lib;
let cfg = config.localModules.docker;
in {
  options.localModules.docker.enable = mkEnableOption "Docker";

  config = mkIf cfg.enable (mkMerge [
    { virtualisation.docker.enable = true; }

    (optionalAttrs impermanence {
      environment.persistence."/nix/persist".directories =
        [ "/var/lib/docker" ];
    })
  ]);
}
