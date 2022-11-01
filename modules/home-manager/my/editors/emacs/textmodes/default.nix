{ pkgs, ... }:

{
  imports = [ ./org ./csv.nix ./git.nix ./latex.nix ./markdown.nix ./yaml.nix ];

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

    visual-fill-column = {
      enable = true;
      # What does visual-line-mode do? When does it trigger?
      # TODO: Somehow if I remove this, I lose the treemacs blue indicator. Why?
      hook = [ "(visual-line-mode . visual-fill-column-mode)" ];
      # custom = { visual-fill-column-center-text = "t"; };
    };

    olivetti = {
      enable = false;
      custom = { olivetti-body-width = "99"; };
    };

    toc-org = { enable = true; };
  };
}
