final: prev: {
  sddm-sugar-candy = prev.callPackage ./sddm-sugar-candy {
    inherit (prev.libsForQt5) qtgraphicaleffects;
    inherit (final) wallpaper;
  };
  wallpaper = prev.callPackage ./wallpaper { };
}
