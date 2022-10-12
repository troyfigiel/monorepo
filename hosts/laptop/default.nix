{ inputs, lib, self, ... }:

let
  inherit (lib) attrValues;
  inherit (import ../../lib/modules.nix { inherit lib; }) mapModules;
  mylib = import ../../lib/hosts.nix { inherit inputs lib self; };
  system = "x86_64-linux";
in mylib.mkHostFlake {
  inherit system;
  impermanence = true;
  host = "laptop";
  modules = [
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = { impermanence = true; emacs-init = true; };
        users.troy = let
          packages = self.legacyPackages.${system};
          nur-modules = import inputs.nur {
            nurpkgs = packages;
            pkgs = packages;
          };
        in {
          imports = [
            inputs.impermanence.nixosModules.home-manager.impermanence
            nur-modules.repos.rycee.hmModules.emacs-init
            ./home/troy.nix
          ] ++ attrValues (mapModules import ../../modules/home-manager);
        };
      };
    }
    ./system
    ./networking.nix
    ./security.nix
  ];
}
