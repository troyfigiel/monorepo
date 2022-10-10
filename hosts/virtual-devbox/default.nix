{ inputs, self, ... }:

let
  lib = import ../lib.nix { inherit inputs self; };
  system = "aarch64-linux";
in lib.mkHostFlake {
  inherit system;
  host = "virtual-devbox";
  modules = [
    ./configuration.nix
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.troy = let
        packages = self.legacyPackages.${system};
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
