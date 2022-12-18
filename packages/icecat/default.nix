{ fetchFromSavannah, fetchurl, file-rename, gnused, mercurial, python3, rename
, stdenv, wget }:

stdenv.mkDerivation rec {
  name = "icecat";
  version = "b6260130b9808f550bdb35061af2d7962109a181";
  srcs = [
    (fetchFromSavannah {
      repo = "gnuzilla";
      rev = version;
      sha256 = "sha256-ZCX0GVhiHcXeS00JZw+QRMMTlbOi0FlqomzJQfggZKc=";
    })
    #   (fetchurl {
    #     url = "";
    #     sha256 = "";
    #   })
  ];

  buildInputs = [
    (python3.withPackages (ps: [ ps.jsonschema ]))
    gnused
    mercurial
    # TODO: This is the correct file-rename, but it is heavily outdated unfortunately.
    # I have bumped the version myself.
    file-rename
    wget
  ];

  # TODO: This does not seem to work as is. Do I need to replace the quotation marks?
  preCheck = ''
    sed -i makeicecat -e 's|\(/bin/sed|sed\)|${gnused}/bin/sed|'
  '';
}
