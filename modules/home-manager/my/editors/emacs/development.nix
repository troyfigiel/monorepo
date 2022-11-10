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
  };
}
