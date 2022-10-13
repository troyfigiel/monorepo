{ inputs, lib, self, ... }:

let
  inherit (lib) attrValues;
  inherit (import ../../lib/modules.nix { inherit lib; }) mapModules;
  mylib = import ../../lib/hosts.nix { inherit inputs lib self; };
  system = "aarch64-linux";
in mylib.mkHostFlake {
  inherit system;
  host = "virtual-devbox";
  impermanence = false;
  modules = [
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = { impermanence = false; };
        users.troy = let packages = self.legacyPackages.${system};
        in {
          imports = [
            # TODO: It should be enough to know the filename. 
            # I can create a function to deduplicate the many times I have "troy" scattered throughout my code.
            ./home/troy.nix
          ] ++ attrValues (mapModules import ../../modules/home-manager);
        };
      };
    }
  ];
}
