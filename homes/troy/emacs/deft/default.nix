{
  programs.emacs.init.usePackage.deft = {
    enable = true;
    after = [ "org-roam" ];
    config = builtins.readFile ./config.el;
  };
}
