{ inputs, self, ... }:

let
  lib = import ../lib.nix { inherit inputs self; };
  system = "x86_64-linux";
in lib.mkHostFlake {
  inherit system;
  host = "laptop";
  modules = [
    inputs.sops-nix.nixosModules.sops
    inputs.impermanence.nixosModules.impermanence
    # If homeManagerModules is empty, do not put this in here.
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.troy = let
        packages = self.legacyPackages.${system};
        nur-modules = import inputs.nur {
          nurpkgs = packages;
          pkgs = packages;
        };
      in {
        imports = [
          inputs.impermanence.nixosModules.home-manager.impermanence
          nur-modules.repos.rycee.hmModules.emacs-init
          ../../homes/troy
        ];
      };
    }
    ./networking
    ./security
    ./system
    ./configuration.nix
    ./hardware-configuration.nix
  ];
}
