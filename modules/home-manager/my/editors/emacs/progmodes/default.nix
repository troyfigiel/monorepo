{ pkgs, ... }:

{
  imports = [ ./docker.nix ./nix.nix ./python.nix ./sql.nix ./terraform.nix ];

  programs.emacs.init.usePackage = {
    # This is a built-in package.
    electric = {
      enable = true;
      config = ''
        (electric-pair-mode 1)
      '';
    };

    rainbow-delimiters = {
      enable = true;
      hook = [ "(prog-mode . rainbow-delimiters-mode)" ];
    };

    flyspell = {
      enable = true;
      hook = [ "(prog-mode . flyspell-prog-mode)" ];
      extraPackages = [ pkgs.ispell ];
    };

    whitespace-cleanup-mode = {
      enable = true;
      hook = [ "(prog-mode . whitespace-cleanup-mode)" ];
    };

    # TODO: Tree-sitter works great for Nix, but for Python I get an error that the language ABI is too recent.
    # How do I fix this?
    tree-sitter = {
      enable = true;
      hook = [
        "(after-init . global-tree-sitter-mode)"
        "(tree-sitter-after-on . tree-sitter-hl-mode)"
      ];
      extraPackages = [ pkgs.tree-sitter ];
    };

    tree-sitter-langs = { enable = true; };
  };
}
