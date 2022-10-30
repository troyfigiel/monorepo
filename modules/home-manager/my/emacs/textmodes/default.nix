{ pkgs, ... }:

{
  imports =
    [ ./org.nix ./org-roam.nix ./csv.nix ./git.nix ./yaml.nix ./latex.nix ];

  programs.emacs.init.usePackage = {
    flyspell = {
      enable = true;
      hook = [ "(text-mode . flyspell-mode)" ];
      extraPackages = [ pkgs.ispell ];
    };

    whitespace-cleanup-mode = {
      enable = true;
      hook = [ "text-mode" ];
    };
  };
}
