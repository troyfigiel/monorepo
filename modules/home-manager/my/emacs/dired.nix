{ pkgs, ... }:

{
  programs.emacs.init.usePackage = {
    dired = {
      enable = true;
      hook = [
        "(dired-mode . dired-hide-details-mode)"
        "(dired-mode . dired-omit-mode)"
      ];
      custom = {
        dired-hide-details-hide-symlink-targets = "nil";
        # This hides dotfiles by default.
        dired-omit-files = ''"^\\."'';
      };
      config = ''
        (setq dired-listing-switches "-Ahl --group-directories-first --time-style=long-iso")
      '';
      general = [''
        (:keymaps 'dired-mode-map
         "M-+" 'dired-create-empty-file)
      ''];
      extraPackages = [ pkgs.imagemagick pkgs.exiftool ];
    };

    dired-rsync = {
      enable = true;
      general = [''
        (:states 'normal
         :keymaps 'dired-mode-map
         "s" 'dired-rsync)
      ''];
      extraPackages = [ pkgs.rsync ];
    };

    # TODO: This has the same problem as other packages. Once I use general, the autoloading does not work anymore.
    # dired-subtree = {
    #   enable = true;
    #   custom = {
    #     dired-subtree-use-backgrounds = "nil";
    #     dired-subtree-line-prefix = "   ";
    #   };
    #   general = [''
    #     (:states 'normal
    #      :keymaps 'dired-mode-map
    #      "* s" 'dired-subtree-mark-subtree)
    #   ''];
    # };
  };
}
