final: prev: {
  sddm-sugar-candy = prev.callPackage ./sddm-sugar-candy {
    inherit (prev.libsForQt5) qtgraphicaleffects;
    background = ../assets/nixos.jpg;
  };
  tdda = prev.callPackage ./tdda {
    inherit (prev.python3Packages) buildPythonPackage pandas;
  };
}
