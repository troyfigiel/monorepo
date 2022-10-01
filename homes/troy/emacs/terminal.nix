{
  programs.emacs.init.usePackage = {
    term = {
      enable = true;
      # TODO: Should I make "bash" into a Nix variable?
      config = "(setq explicit-shell-file-name \"bash\")";
    };

    # TODO: This package is marked as broken. What should I do with it?
    eterm-256color = {
      enable = false;
      hook = [ "(term-mode . eterm-256color-mode)" ];
    };
  };
}
