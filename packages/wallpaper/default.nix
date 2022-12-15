{ stdenv }:

stdenv.mkDerivation {
  name = "wallpaper";
  src = builtins.path {
    path = ./nixos.jpg;
    name = "wallpaper";
  };
  dontUnpack = true;
  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    install -Dm0644 $src $out/wallpaper.jpg
  '';
}
