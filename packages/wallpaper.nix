{ runCommand, fetchurl }:

runCommand "wallpaper" {
  src = fetchurl {
    url = "https://i.imgur.com/eRcHPLw.png";
    sha256 = "sha256-zwKTby6Etc9oOff5nnBEqoveU79dNDWHkxP1pyVwG6Q=";
  };
} ''
  mkdir -p $out
  cp $src $out/doge.jpg
''
