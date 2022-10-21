{ inputs, self }:

let
  inherit (inputs.nixpkgs.lib) nixosSystem;
  inherit (self) hmModules nixosModules;
in rec {
  createNixosSystem = dir:
    let inherit (import ./${dir}/parameters.nix) machine system impermanence;
    in {
      name = machine;
      value = nixosSystem {
        inherit system;
        specialArgs = { inherit inputs hmModules nixosModules impermanence; };
        pkgs = self.legacyPackages.${system};
        modules = [ { networking.hostName = machine; } ./${dir} ];
      };
    };
}
