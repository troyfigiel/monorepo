{ pkgs, ... }:

{
  imports = [ ./docker.nix ./nix.nix ./python.nix ./sql.nix ./terraform.nix ];

  programs.emacs.init.usePackage = {
    smartparens = {
      enable = true;
      hook = [ "(prog-mode . smartparens-mode)" ];
    };

    rainbow-delimiters = {
      enable = true;
      hook = [ "(prog-mode . rainbow-delimiters-mode)" ];
    };

    flyspell = {
      hook = [ "(prog-mode . flyspell-prog-mode)" ];
      extraPackages = [ pkgs.ispell ];
    };

    whitespace-cleanup-mode = { hook = [ "prog-mode" ]; };
  };
}
