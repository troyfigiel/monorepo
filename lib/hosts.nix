{ inputs, lib, self }:

# TODO: Do we really need the mkHostFlake? It is now a tiny wrapper around nixosConfigurations
let
  inherit (builtins) attrValues;
  inherit (import ./modules.nix { inherit lib; }) mapModules;
in {
  mkHostFlake = { host, system, impermanence, modules ? { } }:
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
        ] ++ attrValues (mapModules import ../modules/nixos);
      };
    };
}
