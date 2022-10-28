{
  programs.emacs.init.usePackage = {
    csv-mode = {
      enable = true;
      hook = [
        "(csv-mode . csv-align-mode)"
        "(csv-mode . csv-guess-set-separator)"
      ];
    };
  };
}
