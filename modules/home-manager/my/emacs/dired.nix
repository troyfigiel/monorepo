{
  programs.emacs.init.usePackage = {
    dired-single = {
      enable = true;
      general = [''
        (:states 'normal
         :keymaps 'dired-mode-map
         "h" 'dired-single-up-directory
         "l" 'dired-single-buffer)
      ''];
    };

    dired-hide-dotfiles = {
      enable = true;
      hook = [ "(dired-mode . dired-hide-dotfiles-mode)" ];
      general = [''
        (:states 'normal
         :keymaps 'dired-mode-map
         "H" 'dired-hide-dotfiles-mode)
      ''];
    };
  };
}
