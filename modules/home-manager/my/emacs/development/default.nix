{ pkgs, ... }:

let leaderKey = "SPC";
in {
  imports = [ ./terminal.nix ./progmodes ./textmodes ];

  programs.emacs.init.usePackage = {
    consult-eglot = { enable = true; };

    apheleia = {
      enable = true;
      hook = [ "(after-init . apheleia-global-mode )" ];
    };

    eglot = {
      enable = true;
      general = [''
        (:states 'normal
         "${leaderKey} e" '(:ignore t :which-key "IDE")
         "${leaderKey} ed" #'eglot-find-declaration
         "${leaderKey} er" #'eglot-rename)
      ''];
    };

    flymake = {
      enable = true;
      general = [''
        (:states 'normal
         "${leaderKey} ec" #'consult-flymake
         "${leaderKey} ef" #'flymake-show-buffer-diagnostics
         "${leaderKey} en" #'flymake-goto-next-error
         "${leaderKey} ep" #'flymake-goto-prev-error)
      ''];
    };

    direnv = {
      enable = true;
      hook = [ "(after-init . direnv-mode)" ];
    };

    project = {
      enable = false;
      config = ''
         (transient-define-prefix project-transient ()
           "project.el transient menu."
           [["Buffers"
        ("b" "Switch to project buffer" project-switch-to-buffer)
        ("k" "Kill project buffers" project-kill-buffers)]
            ["Search"
        ("f" "Find file in project" project-find-file)
        ("F" "Find file in project or external roots" project-or-external-find-file)
        ("g" "Find regexp in project" project-find-regexp)
        ("G" "Find regexp in project or external roots" project-or-external-find-regexp)
        ("R" "Find and replace regexp" project-query-replace-regexp)]
            ["Shell"
        ("s" "Start" project-shell)
        ("!" "Run command" project-shell-command)
        ("&" "Run async command" project-async-shell-command)]
            ["Manage"
        ("D" "Open dired at project root" project-dired)
        ("m" "Open magit status at project root" magit-project-status)
        ("c" "Compile Project" project-compile)
        ("p" "Switch Project" project-switch-project)]])
      '';
      general = [''
        (:states 'normal
         "${leaderKey} p" 'project-transient)
      ''];
    };

    evil-nerd-commenter = {
      enable = true;
      general =
        [ ''(:states 'visual "." 'evilnc-comment-or-uncomment-lines)'' ];
    };

    treemacs = { enable = true; };
  };
}
