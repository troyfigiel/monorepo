{ pkgs, ... }:

{
  programs.emacs.init.usePackage = {
    # I can combine dired, embark and consult very quickly change a large number of files.
    # For example, search for files with consult, export with embark, switch to wdired mode
    # and run a regexp replace. This means I should preferably keep h and l unbound.
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
    };

    dired-ranger = {
      enable = true;
      general = [''
        (:keymaps 'dired-mode-map
         "y" 'dired-ranger-copy
         "C-p" 'dired-ranger-move
         "p" 'dired-ranger-paste)
      ''];
    };

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
