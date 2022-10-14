{ inputs, lib, self }:

let
  inherit (lib) optionals;
  inherit (import ./modules.nix { inherit lib; }) modulesToList;
in {
  mkHostFlake = { host, system, impermanence, home-manager }:
    let inherit (inputs.nixpkgs.lib) nixosSystem;
    in {
      flake.nixosConfigurations.${host} = nixosSystem {
        inherit system;
        specialArgs = { inherit impermanence; };
        pkgs = self.legacyPackages.${system};
        modules = [
          # TODO: Think about how I want to import modules. I cannot import my own sops.nix module if the sops input does not exist.
          # However, maybe not all machines need to have sops. For example VMs might not need sops.
          inputs.sops-nix.nixosModules.sops
          inputs.impermanence.nixosModules.impermanence
          inputs.simple-nixos-mailserver.nixosModules.mailserver
          ../hosts/${host}/configuration.nix
          ../hosts/${host}/hardware-configuration.nix
        ] ++ (map import (modulesToList ../modules/nixos))
          ++ (optionals home-manager ([
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit impermanence; };
                users = {
                  troy = let
                    packages = self.legacyPackages.${system};
                    nur-modules = import inputs.nur {
                      nurpkgs = packages;
                      pkgs = packages;
                    };
                  in {
                    imports = [
                      inputs.impermanence.nixosModules.home-manager.impermanence
                      nur-modules.repos.rycee.hmModules.emacs-init
                      ../hosts/${host}/home/troy.nix
                      /* Note that I still cannot import other Nix files in the default.nix!
                         To import Nix files in my home-manager.user.troy,
                         home-manager already has to exist and I am precisely defining home-manager in this very line.
                         This means it will not be able to find the imports.
                      */
                    ] ++ (map import (modulesToList ../modules/home-manager));
                  };
                };
              };
            }
          ]));
      };
    };
}
