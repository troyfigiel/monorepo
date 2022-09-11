final: prev:

{
  sddm-sugar-candy = prev.callPackage ./pkgs/sddm-sugar-candy { };
  troyfigiel-com = prev.callPackage ./pkgs/troyfigiel-com { };

  # The remote container extension requires version 1.71.0 of vscode.
  # Currently the latest version on nixpkgs is 1.70.2.
  vscode = prev.vscode.overrideAttrs (old: rec {
    version = "1.71.0";
    sha256 = "sha256-38i6BjEYiXTSSXI22FpFAXfrLKOAHpnk8mdPy7Bc2TI=";
    src = let
      plat = "linux-x64";
      archive_fmt = "tar.gz";
    in prev.fetchurl {
      name = "VSCode_${version}_${plat}.${archive_fmt}";
      url = "https://update.code.visualstudio.com/${version}/${plat}/stable";
      inherit sha256;
    };
  });
}
