{ inputs, self, ... }:

let
  inherit (builtins) listToAttrs;
  inherit (inputs.terranix.lib) terranixConfiguration;
  inherit (inputs.nixpkgs.lib) nixosSystem;
  inherit (inputs.self) hmFeatures nixosFeatures terranixFeatures;
in {
  perSystem = { system, ... }: {
    packages.default = terranixConfiguration {
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

  flake.nixosConfigurations = listToAttrs (map (dir:
    let
      parameters = import ./${dir}/parameters.nix;
      inherit (parameters.flake) machine system impermanence;
    in {
      name = machine;
      value = nixosSystem {
        inherit system;
        specialArgs = { inherit inputs hmFeatures nixosFeatures impermanence; };
        pkgs = self.legacyPackages.${system};
        modules = [ { networking.hostName = machine; } ./${dir} ];
      };
    }) [ "cloud-server" "laptop" "virtual-devbox" ]);
}

