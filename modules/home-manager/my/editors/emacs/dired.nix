{
  programs.emacs.init.usePackage = {
    dired = {
      enable = true;
      general = [''
        (:states 'normal
         :keymaps 'dired-mode-map
         "h" 'dired-up-directory
         "l" 'dired-find-file)
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

    peep-dired = {
      enable = true;
      # TODO: How do I enable peep-dired mode automatically?
      # hook = [ "(dired-mode . peep-dired)" ];
    };
  };
}
