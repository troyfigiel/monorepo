{ inputs, lib, self }:

# TODO: Do we really need the mkHostFlake? It is now a tiny wrapper around nixosConfigurations
let
  inherit (builtins) attrValues;
  inherit (import ./modules.nix { inherit lib; }) mapModules;
in {
  mkHostFlake = { host, system, impermanence, modules }:
    let inherit (inputs.nixpkgs.lib) nixosSystem;
    in {
      flake.nixosConfigurations.${host} = nixosSystem {
        inherit system;
        specialArgs = { inherit impermanence; };
        pkgs = self.legacyPackages.${system};
        modules = modules ++ [
          ../hosts/${host}/configuration.nix
          ../hosts/${host}/hardware-configuration.nix
        ] ++ attrValues (mapModules import ../modules/nixos);
      };
    };
}
