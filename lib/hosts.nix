{ inputs, lib, self }:

# TODO: Do we really need the mkHostFlake? It is now a tiny wrapper around nixosConfigurations
let
  inherit (builtins) attrValues;
  inherit (lib) optionalAttrs;
  inherit (import ./modules.nix { inherit lib; }) findNixFilesRec;
in {
  mkHostFlake = { host, system, impermanence, home-manager, modules ? [ ] }:
    let inherit (inputs.nixpkgs.lib) nixosSystem;
    in {
      flake.nixosConfigurations.${host} = nixosSystem {
        inherit system;
        specialArgs = { inherit impermanence; };
        pkgs = self.legacyPackages.${system};
        modules = modules ++ [
          # TODO: Think about how I want to import modules. I cannot import my own sops.nix module if the sops input does not exist.
          # However, maybe not all machines need to have sops. For example VMs might not need sops.
          inputs.sops-nix.nixosModules.sops
          inputs.impermanence.nixosModules.impermanence
          inputs.simple-nixos-mailserver.nixosModules.mailserver
          ../hosts/${host}/configuration.nix
          ../hosts/${host}/hardware-configuration.nix
        ] ++ (map import (findNixFilesRec ../modules/nixos))
          ++ (optionalAttrs home-manager ([
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
                    ] ++ (map import (findNixFilesRec ../modules/home-manager));
                  };
                };
              };
            }
          ]));
      };
    };
}
