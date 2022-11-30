{ trivialBuild, denote }:

trivialBuild {
  pname = "tf-exif";
  src = ./tf-exif.el;
  packageRequires = [ denote ];
}
