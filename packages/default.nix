{ inputs, self, ... }:

{
  perSystem = { system, ... }: {
    legacyPackages = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;

      # Software that is not built for aarch64 does seem to work fine.
      # TODO: Does it make sense setting this for x86_64 systems as well?
      config.allowUnsupportedSystem = true;
      overlays = [ self.overlays.default inputs.emacs-overlay.overlay ];
    };
  };

  flake.overlays.default = final: prev: {
    sddm-sugar-candy = prev.callPackage ./sddm-sugar-candy.nix {
      inherit (prev.libsForQt5) qtgraphicaleffects;
      inherit (final) wallpaper;
    };
    wallpaper = prev.callPackage ./wallpaper.nix { };
    website = prev.callPackage ../website { };
  };
}
