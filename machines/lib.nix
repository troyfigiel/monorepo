{ inputs, self }:

let
  inherit (inputs.nixpkgs.lib) nixosSystem;
  inherit (self) hmFeatures nixosFeatures;
in rec {
  createNixosSystem = dir:
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
    };
}
