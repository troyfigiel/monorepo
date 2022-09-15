{ pkgs }:

pkgs.stdenv.mkDerivation rec {
  pname = "sddm-sugar-candy";
  version = "2b72ef6c6f720fe0ffde5ea5c7c48152e02f6c4f";
  dontBuild = true;

  # This works, but is this the best way to do it?
  # See: https://discourse.nixos.org/t/python-how-to-expose-a-dependencys-bin/283
  # And: https://github.com/NixOS/nixpkgs/issues/43049
  propagatedUserEnvPkgs = with pkgs.libsForQt5.qt5; [
    qtgraphicaleffects
    qtquickcontrols2
    qtsvg
  ];

  src = pkgs.fetchFromGitLab {
    domain = "framagit.org";
    owner = "MarianArlt";
    repo = "sddm-sugar-candy";
    rev = version;
    sha256 = "sha256-XggFVsEXLYklrfy1ElkIp9fkTw4wvXbyVkaVCZq4ZLU=";
  };

  installPhase = ''
    mkdir -p $out/share/sddm/themes
    cp -aR . $out/share/sddm/themes/sugar-candy
  '';
}
