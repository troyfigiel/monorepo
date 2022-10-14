{ inputs, lib, self }:

let
  inherit (builtins) listToAttrs pathExists readDir;
  inherit (lib) mapAttrsToList removeSuffix;
  inherit (import ./modules.nix { inherit lib; }) modulesToList;
in rec {
  homeExists = machine: pathExists ../machines/${machine}/home;

  usersToList = machine:
    mapAttrsToList (name: value: removeSuffix ".nix" name)
    (readDir ../machines/${machine}/home);

  createUserConfig = { system, machine }:
    user: {
      name = user;
      value = let
        packages = self.legacyPackages.${system};
        nur-modules = import inputs.nur {
          nurpkgs = packages;
          pkgs = packages;
        };
      in {
        imports = [
          inputs.impermanence.nixosModules.home-manager.impermanence
          nur-modules.repos.rycee.hmModules.emacs-init
          ../machines/${machine}/home/${user}.nix
          /* Note that I still cannot import other Nix files in the default.nix!
             To import Nix files in my home-manager.user.troy,
             home-manager already has to exist and I am precisely defining home-manager in this very line.
             This means it will not be able to find the imports.
          */
        ] ++ (map import (modulesToList ../roles/home-manager));
      };
    };

  homeManagerUsers = { system, machine }:
    listToAttrs
    (map (createUserConfig { inherit system machine; }) (usersToList machine));
}
