_final: prev: {
  tf-exif =
    prev.callPackage ./exif { inherit (prev.emacs.pkgs) trivialBuild denote; };
}
