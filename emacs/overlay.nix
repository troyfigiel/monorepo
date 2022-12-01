_final: prev: {
  tf-exif = prev.callPackage ./tf/exif {
    inherit (prev.emacs.pkgs) trivialBuild denote;
  };
}
