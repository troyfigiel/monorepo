{
  programs.emacs.init.usePackage = {
    consult-eglot = { enable = true; };

    # TODO: This requires black and prettier to be installed
    apheleia = {
      enable = true;
      config = "(apheleia-global-mode 1)";
    };

    # TODO: This requires pylsp and flake8 to be installed
    eglot = {
      enable = true;
      hook = [
        "(python-mode . eglot-ensure)"
        "(terraform-mode . eglot-ensure)"
        "(nix-mode . eglot-ensure)"
        "(sql-mode . eglot-ensure)"
      ];
      config = ''
        (setq-default
         eglot-workspace-configuration
         ;; IDEA: It would be nice to have refactoring capabilities with pylsp-rope.
         ;; Unfortunately, it is not packaged for Nix yet.
         '((pylsp
            (plugins
             ;; I use apheleia + black for formatting so do not need autopep8.
             (autopep8 (enabled . nil))
             (pycodestyle (enabled . nil))
             (flake8 (enabled . t))
             (jedi_completion (fuzzy . t))))))
      '';
    };

    flymake = { enable = true; };

    xref = { enable = true; };
  };
}
