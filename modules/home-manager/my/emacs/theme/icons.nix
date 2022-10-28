{ pkgs, ... }:

{
  programs.emacs.init.usePackage = {
    all-the-icons = {
      enable = true;
      extraPackages = [ pkgs.emacs-all-the-icons-fonts ];
    };

    all-the-icons-dired = {
      enable = true;
      hook = [ "(dired-mode . all-the-icons-dired-mode)" ];
    };
  };
}
