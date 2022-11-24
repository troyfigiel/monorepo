{
  programs.emacs.init.usePackage = {
    eshell = {
      enable = true;
      custom = {
        eshell-banner-message = ''""'';
        eshell-cp-overwrite-files = "nil";
        eshell-mv-overwrite-files = "nil";
      };
      general = [''
        (:keymaps 'eshell-mode-map
         :states 'insert
         "C-r" 'consult-history)
      ''];
    };
  };
}
