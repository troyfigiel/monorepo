{ stdenv, fetchFromGitLab, }:

stdenv.mkDerivation rec {
  pname = "sddm-sugar-candy";
  version = "2b72ef6c6f720fe0ffde5ea5c7c48152e02f6c4f";
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/share/sddm/themes
    cp -aR . $out/share/sddm/themes/sugar-candy
  '';
  src = fetchFromGitLab {
    domain = "framagit.org";
    owner = "MarianArlt";
    repo = "sddm-sugar-candy";
    rev = version;
    sha256 = "sha256-XggFVsEXLYklrfy1ElkIp9fkTw4wvXbyVkaVCZq4ZLU=";
  };
}
