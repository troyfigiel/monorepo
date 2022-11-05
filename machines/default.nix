{ inputs, self, ... }:

# TODO: It would be simpler to just import all my hmModules and nixosModules here.
# All modules should be hidden behind an enable option anyway.
let
  inherit (inputs.nixpkgs.lib) nixosSystem;
  inherit (self) hmModules nixosModules;
  createNixosSystem = dir:
    let parameters = import ./${dir}/parameters.nix;
    in {
      name = parameters.flake.machine;
      value = nixosSystem {
        inherit (parameters.flake) system;
        specialArgs = {
          inherit inputs hmModules nixosModules;
          inherit (parameters.flake) impermanence;
        };
        pkgs = self.legacyPackages.${parameters.flake.system};
        modules =
          [ { networking.hostName = parameters.flake.machine; } ./${dir} ];
      };
    };
in {
  flake.nixosConfigurations = builtins.listToAttrs
    (map createNixosSystem [ "cloud-server" "laptop" "virtual-devbox" ]);
}
