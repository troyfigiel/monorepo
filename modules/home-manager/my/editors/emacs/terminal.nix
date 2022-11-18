{
  programs.emacs.init.usePackage = {
    term = {
      enable = true;
      # TODO: Should I make "zsh" into a Nix variable?
      custom = { explicit-shell-file-name = ''"zsh"''; };
    };
  };
}
