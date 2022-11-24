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
      extraPackages = [ pkgs.imagemagick ];
    };

    # dired-du = {
    #   enable = true;
    #   custom = { dired-du-size-format = "t"; };
    # };

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
