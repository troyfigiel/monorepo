{
  programs.emacs.init.usePackage = {
    elfeed = { enable = true; };
    elfeed-org = {
      enable = true;
      after = [ "elfeed" ];
    };
    elfeed-tube = {
      enable = true;
      after = [ "elfeed" ];
    };
  };
}
