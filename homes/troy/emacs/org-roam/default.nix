{
  programs.emacs.init.usePackage.org-roam = {
    enable = true;
    after = [ "org" ];
    config = builtins.readFile config.el;
  };
}
