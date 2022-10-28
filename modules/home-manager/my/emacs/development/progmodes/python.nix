{ pkgs, ... }:

let leaderKey = "SPC";
in {
  programs.emacs.init.usePackage = {
    eglot = {
      hook = [ "(python-mode . eglot-ensure)" ];
      config = ''
        (setq-default
         eglot-workspace-configuration
         ;; TODO: It would be nice to have refactoring capabilities with pylsp-rope.
         ;; Unfortunately, it is not packaged for Nix yet.
         '((pylsp
            (plugins
             ;; I use apheleia + black for formatting so do not need autopep8.
             (autopep8 (enabled . nil))
             (pycodestyle (enabled . nil))
             (flake8 (enabled . t))
             (jedi_completion (fuzzy . t))))))
      '';
      extraPackages = [
        pkgs.python3Packages.python-lsp-server
        # pkgs.python3Packages.pylsp-rope
        # pkgs.python3Packages.pylsp-mypy
        pkgs.python3Packages.flake8
      ];
    };

    apheleia = { extraPackages = [ pkgs.black ]; };

    python = {
      enable = true;
      # TODO: Set "python3" using a Nix expression such as config.python3
      custom = {
        python-shell-interpreter = ''"python3"'';
        dap-python-executable = ''"python3"'';
        dap-python-debugger = "'debugpy";
      };
      general = [''
        (:states 'normal
         "${leaderKey} l"  '(:ignore t :which-key "languages")
         "${leaderKey} lp" '(:ignore t :which-key "python"))
      ''];
    };

    pyvenv = {
      enable = true;
      config = "(pyvenv-mode 1)";
      general = [''
        (:states 'normal
         "${leaderKey} lpv"  '(:ignore t :which-key "pyvenv")
         "${leaderKey} lpva" 'pyvenv-activate
         "${leaderKey} lpvd" 'pyvenv-deactivate)
      ''];
    };

    poetry = {
      enable = true;
      general = [''
        (:states 'normal
         "${leaderKey} lpp" 'poetry)
      ''];
    };
  };
}
