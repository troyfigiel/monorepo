{ lib, stdenv, fetchurl, perl, perlPackages }:

perlPackages.buildPerlPackage {
  pname = "File-Rename";
  version = "1.31";

  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RM/RMBARKER/File-Rename-1.31.tar.gz";
    sha256 = "sha256-+8jPUlyBqniiZE1V3/X7qT9CZuQJ+ggV3s4XFDYVqbY=";
  };

  # Fix an incorrect platform test that misidentifies Darwin as Windows
  postPatch = ''
    substituteInPlace Makefile.PL \
      --replace '/win/i' '/MSWin32/'
  '';

  postFixup = ''
    substituteInPlace $out/bin/rename \
      --replace "#!${perl}/bin/perl" "#!${perl}/bin/perl -I $out/${perl.libPrefix}"
  '';

  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    description = "Perl extension for renaming multiple files";
    license = licenses.artistic1;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
