{ inputs, lib, self, ... }:

let
  mylib = import ../../lib/hosts.nix { inherit inputs lib self; };
  system = "aarch64-linux";
in mylib.mkHostFlake {
  inherit system;
  host = "virtual-devbox";
  impermanence = false;
  modules = [
    inputs.sops-nix.nixosModules.sops
    inputs.impermanence.nixosModules.impermanence
    inputs.simple-nixos-mailserver.nixosModules.mailserver
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.troy = let packages = self.legacyPackages.${system};
      in {
        imports = [
          ./home.nix
          self.homeManagerModules.alacritty
          self.homeManagerModules.git
          self.homeManagerModules.vscode
          self.homeManagerModules.xdg-no-persist
        ];
      };
    }
  ];
}
