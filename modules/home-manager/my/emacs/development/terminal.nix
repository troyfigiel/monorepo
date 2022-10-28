{
  programs.emacs.init.usePackage = {
    term = {
      enable = true;
      # TODO: Should I make "zsh" into a Nix variable?
      custom = { explicit-shell-file-name = ''"zsh"''; };
    };

    # TODO: This package is marked as broken. What should I do with it?
    eterm-256color = {
      enable = false;
      hook = [ "(term-mode . eterm-256color-mode)" ];
    };
  };
}
