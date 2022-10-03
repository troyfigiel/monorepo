{
  programs.emacs.init.usePackage = {
    magit = {
      enable = true;
      config = ''
        (setq magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1)
        (setq vc-follow-symlinks t)
      '';
    };

    hl-todo = {
      enable = true;
      config = ''
        (setq hl-todo-keyword-faces
         '(("TODO" . "#cc9393")
           ("TODOC" . "#afd8af")
           ("BUG" . "#d0bf8f")
           ("IDEA" . "#7cb8bb")))
        (global-hl-todo-mode 1)
      '';
    };

    magit-todos = {
      enable = true;
      after = [ "hl-todo" ];
      # TODO: Indent this config properly
      config = ''
        (setq magit-todos-branch-list nil)
        (magit-todos-mode 1)
      '';
    };

    # TODO: I skipped setting the custom faces for now. How can I do that with emacs-init?
    diff-hl = {
      enable = true;
      hook = [ "(dired-mode . diff-hl-dired-mode)" ];
      config = ''
        (setq diff-hl-margin-symbols-alist
         ;; I prefer to use background colours instead.
         '((insert . " ")
           (delete . " ")
           (change . " ")
           (unknown . "?")
           (ignored . "i")))
        ;; This mode will instantly show changes instead of only after saving the file.
        ;; I like the immediate feedback better. Especially because if I am using super
        ;; save mode, I should not have to think about saving at all.
        (diff-hl-flydiff-mode 1)
        ;; TODOC: What difference does this mode actually make? The help was not that clear.
        (diff-hl-margin-mode 1)
        (global-diff-hl-mode 1)
      '';
    };
  };
}
