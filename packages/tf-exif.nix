{ trivialBuild, denote }:

trivialBuild {
  pname = "tf-exif";
  src = ../modules/home-manager/my/emacs/extensions/tf-exif.el;
  packageRequires = [ denote ];
}
