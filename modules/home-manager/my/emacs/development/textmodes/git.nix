let leaderKey = "SPC";
in {
  programs.emacs.init.usePackage = {
    git-modes = { enable = true; };

    magit = {
      enable = true;
      custom = { vc-follow-symlinks = "t"; };
      general = [''
        (:states 'normal
         "${leaderKey} g" 'magit-status)
      ''];
    };

    hl-todo = {
      enable = true;
      hook = [ "(after-init . global-hl-todo-mode)" ];
      custom = {
        hl-todo-keyword-faces = ''
          '(("TODO" . "#dd9393"))
        '';
      };
    };

    magit-todos = {
      enable = true;
      after = [ "hl-todo" ];
      hook = [ "(global-hl-todo-mode . magit-todos-mode)" ];
      custom = { magit-todos-branch-list = "nil"; };
    };

    diff-hl = {
      enable = true;
      hook = [
        # TODO: For some reason diff-hl-dired-mode and diff-hl-flydiff-mode are not included in this package. Why?
        # "(dired-mode . diff-hl-dired-mode)"
        # This mode will instantly show changes instead of only after saving the file.
        # "(after-init . diff-hl-flydiff-mode)"
        "(after-init . global-diff-hl-mode)"
      ];
      custom = {
        # TODO: I prefer to use background colours instead. I will need to add faces to my Nix emacs-init.
        diff-hl-margin-symbols-alist = ''
          '((insert . " ")
            (delete . " ")
            (change . " ")
            (unknown . "?")
            (ignored . "i"))
        '';
      };
    };
  };
}
