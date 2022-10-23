{ inputs, self, ... }:

let
  inherit (inputs.nixpkgs.lib) nixosSystem;
  inherit (self) hmModules nixosModules;
in {
  flake.nixosConfigurations = {
    aarch64-linux-devbox = nixosSystem rec {
      system = "aarch64-linux";
      specialArgs = {
        inherit inputs hmModules nixosModules;
        impermanence = true;
      };
      pkgs = self.legacyPackages.${system};
      modules = [
        { networking.hostName = "aarch64-linux-devbox"; }
        ./hardware/aarch64-linux.nix
        ./nixos/qemu.nix
      ];
    };
  };
}
