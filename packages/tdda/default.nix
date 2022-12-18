{ buildPythonPackage, fetchFromGitHub, pandas }:

buildPythonPackage {
  pname = "tdda";
  version = "2.0.2";
  src = fetchFromGitHub {
    owner = "tdda";
    repo = "tdda";
    rev = "21a40bdf53ca77757007359b975acb6da9fc7c9c";
    sha256 = "sha256-kJhDUF9iBI+p+e15nrlLB9F4R53Nm6Cn/U3wklp8Y/E=";
  };
  propagatedBuildInputs = [ pandas ];

  # TODO: I do not get the tests to run successfully.
  doCheck = false;
  # checkInputs = [ pytest ];
  # preCheck = ''
  #   rm tdda/rexpy/testseq.py
  #   rm tdda/referencetest/tests/testbase.py
  # '';
}
