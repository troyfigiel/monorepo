{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "wallpaper";
  src = fetchurl {
    url =
      "https://raw.githubusercontent.com/jpotier/nixos-wallpapers/0ef76739f1be240ee3c815442cfddcca0e8280f3/nixos-data-center.png";
    sha256 = "sha256-PVn0dP4ICkQJVlewJzwIk8Ym4ZqBVrc/hdmx+kQ1gjc=";
  };
  dontUnpack = true;
  dontBuild = true;
  dontConfigur = true;

  installPhase = ''
    install -Dm0644 $src $out/wallpaper.png
  '';
}
