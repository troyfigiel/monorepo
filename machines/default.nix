{ inputs, self, ... }:

let
  inherit (builtins) listToAttrs;
  inherit (inputs.terranix.lib) terranixConfiguration;
  inherit (self) terranixModules;
  inherit (import ./lib.nix { inherit inputs self; }) createNixosSystem;
in {
  perSystem = { system, ... }: {
    packages.terra = terranixConfiguration {
      inherit system;
      modules = [
        terranixModules.machines.vultr
        terranixModules.records.mail
        terranixModules.records.searx
        terranixModules.records.webhosting
        ./cloud-server/terra.nix
        ./terra.nix
      ];
    };
  };

  flake.nixosConfigurations = listToAttrs
    (map createNixosSystem [ "cloud-server" "laptop" "virtual-devbox" ]);
}
