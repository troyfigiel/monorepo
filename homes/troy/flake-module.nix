{ inputs, self, ... }:

let
  system = "aarch64-linux";
  inherit (inputs.home-manager.lib) homeManagerConfiguration;
in {
  flake = {
    homeConfigurations.troy = homeManagerConfiguration {
      pkgs = self.nixosConfigurations.laptop.pkgs;
      modules = let
        nur-modules = import inputs.nur {
          nurpkgs = self.legacyPackages.x86_64-linux;
          pkgs = self.legacyPackages.x86_64-linux;
        };
      in [
        ./.
        inputs.impermanence.nixosModules.home-manager.impermanence
        nur-modules.repos.rycee.hmModules.emacs-init
      ];
    };
  };
}
