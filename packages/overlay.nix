final: prev: {
  file-rename = prev.callPackage ./file-rename { };
  icecat = prev.callPackage ./icecat { };
  sddm-sugar-candy = prev.callPackage ./sddm-sugar-candy {
    inherit (prev.libsForQt5) qtgraphicaleffects;
    inherit (final) wallpaper;
  };
  tdda = prev.callPackage ./tdda {
    inherit (prev.python3Packages) buildPythonPackage pandas;
  };
  wallpaper = prev.callPackage ./wallpaper { };
}
