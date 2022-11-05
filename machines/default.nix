{ inputs, self, ... }:

# TODO: It would be simpler to just import all my hmModules and nixosModules here.
# All modules should be hidden behind an enable option anyway.
let
  inherit (inputs.nixpkgs.lib) nixosSystem;
  inherit (self) hmModules nixosModules;
  parameters = import ./parameters.nix;
  createNixosSystem = dir: {
    name = parameters.${dir}.machine;
    value = nixosSystem {
      inherit (parameters.${dir}) system;
      specialArgs = {
        inherit inputs hmModules nixosModules;
        inherit (parameters.${dir}) impermanence;
      };
      pkgs = self.legacyPackages.${parameters.${dir}.system};
      modules =
        [ { networking.hostName = parameters.${dir}.machine; } ./${dir} ];
    };
  };
in {
  flake.nixosConfigurations = builtins.listToAttrs
    (map createNixosSystem [ "cloud-server" "laptop" "virtual-devbox" ]);
}
