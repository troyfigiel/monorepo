{
  programs.emacs.init.usePackage = {
    saveplace = {
      enable = true;
      config = "(save-place-mode 1)";
    };

    savehist = {
      enable = true;
      config = "(savehist-mode 1)";
    };

    super-save = {
      enable = true;
      hook = [ "(find-file . (lambda () (setq buffer-save-without-query t)))" ];
      config = "(super-save-mode 1)";
    };

    persistent-scratch = {
      enable = true;
      config = ''
          (setq persistent-scratch-backup-directory
                (concat (file-name-as-directory no-littering-var-directory)
        	            "persistent-scratch-backups"))
          (persistent-scratch-autosave-mode 1)
          (persistent-scratch--auto-restore)
      '';
    };
  };
}
