{ inputs, self, ... }:

{
  perSystem = { system, ... }: {
    legacyPackages = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [
        self.overlays.default
        inputs.nix-vscode-marketplace.overlays.${system}.default
        inputs.emacs-overlay.overlay
      ];
    };
  };

  flake.overlays.default = final: prev: {
    sddm-sugar-candy = prev.callPackage ./sddm-sugar-candy.nix { };
    website = prev.callPackage ../website { };
  };
}