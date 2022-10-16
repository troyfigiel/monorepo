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
        modules = let
          inputModules = [
            inputs.sops-nix.nixosModules.sops
            inputs.impermanence.nixosModules.impermanence
            inputs.simple-nixos-mailserver.nixosModules.mailserver
          ];

          configurationModules = [
            { networking.hostName = machine; }
            ../machines/${machine}/configuration.nix
            ../machines/${machine}/hardware-configuration.nix
          ];

          roleModules = map import (modulesToList ../features/nixos);

          homeManagerModules = [
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit impermanence; };
                users = homeManagerUsers { inherit system machine; };
              };
            }
          ];
        in inputModules ++ configurationModules ++ roleModules
        ++ (optionals (homeExists machine) homeManagerModules);
      };
    };
}
