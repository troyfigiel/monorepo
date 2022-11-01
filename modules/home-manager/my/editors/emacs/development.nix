{ pkgs, ... }:

let leaderKey = "C-c";
in {
  programs.emacs.init.usePackage = {
    consult-eglot = { enable = true; };

    apheleia = {
      enable = true;
      hook = [ "(after-init . apheleia-global-mode )" ];
    };

    linum = {
      enable = true;
      hook = [ "(prog-mode . linum-mode)" ];
    };

    eglot = {
      enable = true;
      general = [''
        (:prefix "${leaderKey}"
         "e" '(:ignore t :which-key "IDE")
         "ed" #'eglot-find-declaration
         "er" #'eglot-rename)
      ''];
    };

    flymake = {
      enable = true;
      general = [''
        (:prefix "${leaderKey}"
         "ec" #'consult-flymake
         "ef" #'flymake-show-buffer-diagnostics
         "en" #'flymake-goto-next-error
         "ep" #'flymake-goto-prev-error)
      ''];
    };

    direnv = {
      enable = true;
      hook = [ "(after-init . direnv-mode)" ];
    };

    project = {
      enable = true;
      general = [''
        (:prefix "${leaderKey}"
         "p" '(:ignore t :which-key "project")
         "pb" #'project-switch-to-buffer
         "pk" #'project-kill-buffers
         "pf" #'project-find-file
         "pF" #'project-or-external-find-file
         "pg" #'project-find-regexp
         "pG" #'project-or-external-find-regexp
         "pR" #'project-query-replace-regexp
         "ps" #'project-shell
         "p!" #'project-shell-command
         "p&" #'project-async-shell-command
         "pp" #'project-switch-project)
      ''];
    };

    evil-nerd-commenter = {
      enable = true;
      general =
        [ ''(:states 'visual "." 'evilnc-comment-or-uncomment-lines)'' ];
    };
  };
}
