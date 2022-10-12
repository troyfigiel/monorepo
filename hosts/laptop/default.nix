{ inputs, lib, self, ... }:

let
  mylib = import ../../lib/hosts.nix { inherit inputs lib self; };
  system = "x86_64-linux";
in mylib.mkHostFlake {
  inherit system;
  impermanence = true;
  host = "laptop";
  modules = [
    inputs.sops-nix.nixosModules.sops
    inputs.impermanence.nixosModules.impermanence
    inputs.simple-nixos-mailserver.nixosModules.mailserver
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.troy = let
        packages = self.legacyPackages.${system};
        nur-modules = import inputs.nur {
          nurpkgs = packages;
          pkgs = packages;
        };
      in {
        imports = [
          inputs.impermanence.nixosModules.home-manager.impermanence
          nur-modules.repos.rycee.hmModules.emacs-init
          ./home
          self.homeManagerModules.alacritty
          self.homeManagerModules.dunst
          self.homeManagerModules.git
          self.homeManagerModules.i3
          self.homeManagerModules.picom
          self.homeManagerModules.polybar
          self.homeManagerModules.smb
          self.homeManagerModules.syncthing
          self.homeManagerModules.vscode
          self.homeManagerModules.xdg
        ];
      };
    }
    ./system
    ./networking.nix
    ./security.nix
  ];
}
