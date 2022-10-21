{ inputs, self, ... }:

let
  inherit (builtins) listToAttrs;
  inherit (inputs.terranix.lib) terranixConfiguration;
  inherit (import ./lib.nix { inherit inputs self; }) createNixosSystem;
in {
  perSystem = { system, ... }: {
    packages.default = terranixConfiguration {
      inherit system;
      modules = [
        ./cloud-server/terra/cloud-server.nix
        ./cloud-server/terra/dns.nix
        ./terra.nix
      ];
    };
  };

  flake.nixosConfigurations = listToAttrs
    (map createNixosSystem [ "cloud-server" "laptop" "virtual-devbox" ]);
}

