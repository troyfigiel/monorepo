{ pkgs, ... }:

{
  programs.emacs.init.usePackage = {
    dired = {
      enable = true;
      hook = [ "(dired-mode . dired-hide-details-mode)" ];
      custom = { dired-hide-details-hide-symlink-targets = "nil"; };
      config = ''
        (setq dired-listing-switches "-Ahl --group-directories-first --time-style=long-iso")
      '';
      general = [''
        (:keymaps 'dired-mode-map
         "M-+" 'dired-create-empty-file)
      ''];
      extraPackages = [ pkgs.imagemagick ];
    };

    dired-du = {
      enable = false;
      custom = { dired-du-size-format = "t"; };
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
  };
}
