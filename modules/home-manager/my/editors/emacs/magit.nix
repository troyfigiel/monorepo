let leaderKey = "C-c";
in {
  programs.emacs.init.usePackage = {
    magit = {
      enable = true;
      custom = {
        vc-follow-symlinks = "t";
        magit-display-buffer-function =
          "#'magit-display-buffer-same-window-except-diff-v1";
      };
      general = [ ''(:prefix "${leaderKey}" "g" 'magit-status)'' ];
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
        # TODO: I do not really need the global mode right? Let's hook it behind prog-mode and give that a try for a while.
        "(prog-mode . diff-hl-mode)"
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
