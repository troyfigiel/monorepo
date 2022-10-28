{ pkgs, ... }:

{
  programs.emacs.init.usePackage = {
    apheleia = { extraPackages = [ pkgs.nodePackages.prettier ]; };

    yaml-mode = { enable = true; };

    yaml-pro = { enable = true; };
  };
}
