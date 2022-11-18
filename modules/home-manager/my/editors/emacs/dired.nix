{ pkgs, ... }:

{
  programs.emacs.init.usePackage = {
    dired = {
      enable = true;
      hook = [ "(dired-mode . dired-hide-details-mode)" ];
      config = ''
        (setq dired-listing-switches "-Ahl --group-directories-first --time-style=long-iso")
      '';
      general = [''
        (:keymaps 'dired-mode-map
         "M-+" 'dired-create-empty-file)
      ''];
      extraPackages = [ pkgs.imagemagick ];
    };

    # TODO: It seems this does not automatically load functions that I might need.
    dired-du = {
      enable = true;
      custom = { dired-du-size-format = "t"; };
      # TODO: What is a character mark? By default dired-du-count-sizes is bound to *N.
      general = [''
        (:states 'normal
         :keymaps 'dired-mode-map
         "N" 'dired-du-count-sizes)
      ''];
    };

    # dired-ranger = {
    #   enable = true;
    #   general = [''
    #     (:states 'normal
    #      :keymaps 'dired-mode-map
    #      "y" 'dired-ranger-copy
    #      "C-p" 'dired-ranger-move
    #      "p" 'dired-ranger-paste)
    #   ''];
    # };

    # dired-open = {
    #   enable = true;
    #   # TODO: This key does not work in terminal mode. Which key would work? Control in the GUI mode does not always seem to map to control in the terminal mode.
    #   # TODO: How do I set the xdg-open programs to run?
    #   general = [''
    #     (:states '(insert normal visual)
    #      :keymaps 'dired-mode-map
    #      "C-RET" 'dired-open-xdg)
    #   ''];
    #   extraPackages = [ pkgs.xdg-utils ];
    # };

    dired-subtree = { enable = true; };

    # diredfl = {
    #   enable = true;
    #   hook = [ "(dired-mode . diredfl-mode)" ];
    # };

    # TODO: Check how this works with SSH. How does this compare to TRAMP? Does TRAMP not have rsync built-in?
    dired-rsync = {
      enable = true;
      general = [''
        (:states 'normal
         :keymaps 'dired-mode-map
         "s" 'dired-rsync)
      ''];
      extraPackages = [ pkgs.rsync ];
    };
  };
}
