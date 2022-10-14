{ inputs, lib, self }:

let
  inherit (lib) optionals;
  inherit (import ./modules.nix { inherit lib; }) modulesToList;
  inherit (import ./home.nix { inherit inputs lib self; })
    homeExists homeManagerUsers;
in {
  mkMachineFlake = { machine, system, impermanence }:
    let inherit (inputs.nixpkgs.lib) nixosSystem;
    in {
      flake.nixosConfigurations.${machine} = nixosSystem {
        inherit system;
        specialArgs = { inherit impermanence; };
        pkgs = self.legacyPackages.${system};
        modules = [
          inputs.sops-nix.nixosModules.sops
          inputs.impermanence.nixosModules.impermanence
          inputs.simple-nixos-mailserver.nixosModules.mailserver
          ../machines/${machine}/configuration.nix
          ../machines/${machine}/hardware-configuration.nix
        ] ++ (map import (modulesToList ../roles/nixos))
          ++ (optionals (homeExists machine) ([
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit impermanence; };
                users = homeManagerUsers { inherit system machine; };
              };
            }
          ]));
      };
    };
}
