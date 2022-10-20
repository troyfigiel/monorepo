# TODO: Remove the persistent scratch configuration. I need to trim my config down significantly.
# TODO: Add the settings for Emacs itself
# TODO: Add latex.el from my emacs.d
# TODO: I left of at roam.el. Add the files onwards.
{ pkgs, ... }:

let leaderKey = "SPC";
in {
  programs.emacs.init.usePackage = {
    # TODO: This should not be here, but for some reason I cannot use (require 'no-littering) in either prelude or earlyInit of the usePackage definition.
    # I am not sure why this does not work. Maybe a bug in the home-manager module? This is a work-around for now.
    # I think the problem is that no-littering is trying to create a directory. This error is specific to no-littering.
    no-littering = {
      enable = true;
      config = ''
        (setq auto-save-file-name-transforms
         `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))
      '';
    };

    pinentry = {
      enable = true;
      custom = { epg-pinentry-mode = "'loopback"; };
      config = "(pinentry-start)";
    };

    vertico = {
      enable = true;
      config = "(vertico-mode 1)";
    };

    vertico-buffer = {
      enable = true;
      after = [ "vertico" ];
      custom = {
        vertico-buffer-display-action = ''
          `(display-buffer-in-side-window
            (window-height . ,(+ 3 vertico-count))
            (side . top))
        '';
        vertico-buffer-mode = "t";
      };
    };

    vertico-directory = {
      enable = true;
      after = [ "vertico" ];
      hook = [ "(rfn-eshadow-update-overlay . vertico-directory-tidy)" ];
      general = [''
        (:keymaps 'vertico-map
         "RET" 'vertico-directory-enter
         "DEL" 'vertico-directory-delete-char
         "M-DEL" 'vertico-directory-delete-word)
      ''];
    };

    orderless = {
      enable = true;
      custom = {
        completion-styles = "'(orderless)";
        completion-category-defaults = "nil";
        completion-category-overrides =
          "'((file (styles . (partial-completion))))";
        orderless-matching-styles = "'(orderless-prefixes)";
      };
    };

    consult = { enable = true; };

    marginalia = {
      enable = true;
      custom = { marginalia-mode = "t"; };
    };

    embark = {
      enable = true;
      general = [''
        (("C-." embark-act)
        ("M-." embark-dwim)
        ("C-h B" embark-bindings))
      ''];
    };

    embark-consult = { enable = true; };

    ace-window = {
      enable = true;
      custom = { aw-keys = "'(?a ?s ?d ?f ?g ?h ?j ?k ?l)"; };
      general = [ ''("C-M-w" 'ace-window)'' ];
    };

    corfu = {
      enable = true;
      custom = {
        corfu-auto = "t";
        corfu-auto-prefix = "2";
        corfu-cycle = "t";
        corfu-auto-delay = "0.1";
        global-corfu-mode = "t";
      };
    };

    prescient = {
      enable = true;
      config = "(prescient-persist-mode 1)";
    };

    which-key = {
      enable = true;
      config = "(which-key-mode 1)";
    };

    helpful = {
      enable = true;
      custom = {
        describe-function-function = "#'helpful-callable";
        describe-variable-function = "#'helpful-variable";
      };
    };

    undo-fu = { enable = true; };

    undo-fu-session = { enable = true; };

    vundo = { enable = true; };

    default-text-scale = { enable = true; };

    page-break-lines = {
      enable = true;
      config = "(global-page-break-lines-mode 1)";
    };

    flyspell = {
      enable = true;
      hook =
        [ "(text-mode . flyspell-mode)" "(prog-mode . flyspell-prog-mode)" ];
      extraPackages = [ pkgs.ispell ];
    };

    whitespace-cleanup-mode = {
      enable = true;
      hook = [ "prog-mode" "text-mode" ];
    };

    consult-eglot = { enable = true; };

    apheleia = {
      enable = true;
      custom = { apheleia-global-mode = "t"; };
      extraPackages = [ pkgs.black pkgs.nodePackages.prettier ];
    };

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
      general = [''
        (:states 'normal
         "${leaderKey} e" '(:ignore t :which-key "IDE")
         "${leaderKey} ed" #'eglot-find-declaration
         "${leaderKey} er" #'eglot-rename)
      ''];
      extraPackages = [
        pkgs.python3Packages.python-lsp-server
        # pkgs.python3Packages.pylsp-rope
        # pkgs.python3Packages.pylsp-mypy
        pkgs.python3Packages.flake8
        pkgs.terraform-ls
        pkgs.sqls
        pkgs.rnix-lsp
        # pkgs.docker-langserver
      ];
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

    xref = { enable = true; };

    evil = {
      enable = true;
      config = ''
        (evil-set-initial-state 'messages-buffer-mode 'normal)
        (evil-set-initial-state 'dashboard-mode 'normal)
      '';
      general = [''
        (:states 'motion
         "j" 'evil-next-visual-line
         "k" 'evil-previous-visual-line) 
      ''];
    };

    evil-escape = {
      enable = true;
      custom = {
        evil-escape-unordered-key-sequence = "t";
        evil-escape-key-sequence = ''".,"'';
        evil-escape-delay = "0.2";
        evil-escape-mode = "t";
      };
    };

    evil-nerd-commenter = {
      enable = true;
      general = [''
        ("C-M-#" 'evilnc-comment-or-uncomment-lines)
      ''];
    };

    elfeed = {
      enable = true;
      general = [''
        (:states 'normal
         "${leaderKey} f" 'elfeed)
      ''];
    };

    elfeed-org = {
      enable = true;
      after = [ "elfeed" ];
    };
    elfeed-tube = {
      enable = true;
      after = [ "elfeed" ];
    };

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

    repeat = {
      enable = true;
      config = "(repeat-mode 1)";
    };

    repeat-help = {
      enable = true;
      after = [ "repeat" "embark" ];
      custom = {
        repeat-help-auto = "t";
        repeat-help-mode = "t";
      };
    };

    # Does not exist on emacs-overlay.
    define-repeat-map = { enable = false; };
    # (use-package define-repeat-map
    #   :straight
    #   (:type git
    #    :host nil
    #    :repo "https://tildegit.org/acdw/define-repeat-map.el")
    #   :after repeat)

    nix-mode = {
      enable = true;
      mode = [ ''"\\.nix\\'"'' ];
    };

    terraform-mode = { enable = true; };

    company-terraform = { enable = true; };

    # TODO: With lsp-docker I should be able to implement a workflow similar to vscodes devcontainers.
    lsp-docker = { enable = true; };

    docker = {
      enable = true;
      general = [''
        (:states 'normal
         "${leaderKey} d" 'docker)
      ''];
    };

    dockerfile-mode = { enable = true; };

    docker-compose-mode = { enable = true; };

    yaml-mode = { enable = true; };

    yaml-pro = { enable = true; };

    csv-mode = {
      enable = true;
      hook = [
        "(csv-mode . csv-align-mode)"
        "(csv-mode . csv-guess-set-separator)"
      ];
    };

    ses = {
      enable = true;
      hook = [ "(ses-mode . linum-mode)" ];
    };

    direnv = {
      enable = true;
      custom = { direnv-mode = "t"; };
    };

    project = {
      enable = true;
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

    smartparens = {
      enable = true;
      hook = [ "(prog-mode . smartparens-mode)" ];
    };

    rainbow-delimiters = {
      enable = true;
      hook = [ "(prog-mode . rainbow-delimiters-mode)" ];
    };

    crux = { enable = true; };

    restart-emacs = {
      enable = true;
      general = [''
        (:states 'normal
         "${leaderKey} R" 'restart-emacs)
      ''];
    };

    crontab-mode = {
      enable = true;
      mode = [ ''"\\.?cron\\(tab\\)?\\'"'' ];
    };

    git-modes = {
      enable = true;
      mode = [ ''("\\.dockerignore\\'" . 'gitignore-mode)'' ];
    };

    org = {
      enable = true;
      custom = {
        org-catch-invisible-edits = "'show-and-error";
        org-ellipsis = ''" …"'';
        org-pretty-entities = "t";
        org-hide-emphasis-markers = "t";
        org-startup-with-latex-preview = "t";
      };
      config = ''
        ;; TODO: Create a simple binding for previewing the entire buffer in LaTeX
        ;; TODO: This should be org-cdlatex-mode, but can't get it to work.
        ;; TODO: Does this work as a custom or does it need to be a default?
        (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
        (add-to-list 'org-structure-template-alist '("py" . "src python"))
        (add-to-list 'org-structure-template-alist '("sh" . "src shell"))
        (add-to-list 'org-structure-template-alist '("r" . "src R"))
        (add-to-list 'org-structure-template-alist '("sh" . "src shell"))
        (add-to-list 'org-structure-template-alist '("sq" . "src sql"))
        (org-babel-do-load-languages
         'org-babel-load-languages
         '((emacs-lisp . t)
           (python . t)
           (shell . t)
           (R . t)
           (sql . t)))
        (push '("conf-unix" . conf-unix) org-src-lang-modes)
      '';
    };

    org-modern = {
      enable = true;
      custom = {
        line-spacing = "0.2";
        global-org-modern-mode = "t";
      };
    };

    # TODO: Does this interfere with org-modern?
    # TODO: Find out how well this works compared to the default.
    # (use-package valign
    #   :custom (valign-fancy-bar t)
    #   :hook (org-mode . valign-mode))

    org-sticky-header = {
      enable = true;
      hook = [ "(org-mode . org-sticky-header-mode)" ];
      custom = {
        org-sticky-header-full-path = "'full";
        org-sticky-header-heading-star = ''""'';
      };
    };

    toc-org = {
      enable = true;
      hook = [ "(org-mode . toc-org-mode)" "(markdown-mode . toc-org-mode)" ];
    };

    # BUG: This does not work together well with `diff-hl', because it ends
    # up creating a very large coloured block instead of a small fringe whenever
    # I changed, add or delete something to a git controlled file.
    # IDEA: Can I add `olivetti' and have it work together well with `visual-fill-column'
    # or is it a replacement of that package?
    visual-fill-column = {
      enable = true;
      # What does visual-line-mode do? When does it trigger?
      hook = [ "(visual-line-mode . visual-fill-column-mode)" ];
      custom = { visual-fill-column-center-text = "t"; };
    };

    org-appear = {
      enable = true;
      hook = [ "(org-mode . org-appear-mode)" ];
    };

    # TODO: Does this interfere with org-modern?
    # (use-package org-superstar
    #   :hook (org-mode . org-superstar-mode)
    #   :custom
    #   ;; org-superstar-cycle-headline-bullets: By default we cycle through the list.
    #   ;; org-superstar-leading-bullet: Also by default, the bullets are connected
    #   ;; by . to the left margin.
    #   ;; I can also add a lot of customization to TODOs.
    #   ;; org-superstar-item-bullet-alist also has good defaults.
    #   (org-superstar-headline-bullets-list '("◉" "○"))

    ox-hugo = { enable = true; };

    org-roam = {
      enable = true;
      after = [ "org" ];
      custom = {
        org-roam-directory =
          ''(expand-file-name "notes" (getenv "ORG_DIRECTORY"))'';
        org-roam-completion-everywhere = "t";
      };
      config = ''
        (org-roam-db-autosync-enable)

        (defun band-aid-org-roam-capture-template (keybinding name)
          `(,keybinding
            ,name
            plain
            (file ,(expand-file-name (concat name ".org")))
            :if-new (file "%<%Y%m%d%H%M%S>.org")
            :unnarrowed t))

        (defun band-aid-org-roam-set-templates (template-directory)
          (let ((default-directory template-directory))
            (setq org-roam-capture-templates
        	  (list (band-aid-org-roam-capture-template "d" "default")
        		(band-aid-org-roam-capture-template "i" "index")
        		(band-aid-org-roam-capture-template "f" "facts")
        		(band-aid-org-roam-capture-template "b" "inbox")
        		(band-aid-org-roam-capture-template "a" "appendix")))))

        (band-aid-org-roam-set-templates
          (expand-file-name "templates" (getenv "ORG_DIRECTORY")))
      '';
      general = [''
        (:states 'normal
         "${leaderKey} r"   '(:ignore t :which-key "org-roam")
         "${leaderKey} rb"  'org-roam-buffer-toggle
         "${leaderKey} rn"  '(:ignore t :which-key "node")
         "${leaderKey} rnf" 'org-roam-node-find
         "${leaderKey} rni" 'org-roam-node-insert
         "${leaderKey} rnr" 'org-roam-node-random
         "${leaderKey} ra"  '(:ignore t :which-key "alias")
         "${leaderKey} raa" 'org-roam-alias-add
         "${leaderKey} rar" 'org-roam-alias-remove
         "${leaderKey} rr"  '(:ignore t :which-key "ref")
         "${leaderKey} rra" 'org-roam-ref-add
         "${leaderKey} rrr" 'org-roam-ref-remove
         "${leaderKey} rt"  '(:ignore t :which-key "tag")
         "${leaderKey} rta" 'org-roam-tag-add
         "${leaderKey} rtr" 'org-roam-tag-remove
         "${leaderKey} ra"  '(:ignore t :which-key "add"))
      ''];
    };

    org-roam-bibtex = { enable = true; };

    org-roam-ui = {
      enable = true;
      after = [ "org-roam" ];
      diminish = [ "org-roam-ui-mode" ];
      hook = [ "(after-init . org-roam-ui-mode)" ];
      custom = {
        org-roam-ui-sync-theme = "t";
        org-roam-ui-follow = "t";
        org-roam-ui-update-on-save = "t";
        org-roam-ui-open-on-start = "nil";
      };
    };

    org-roam-timestamps = {
      enable = true;
      after = [ "org-roam" ];
      diminish = [ "org-roam-timestamps-mode" ];
      custom = { org-roam-timestamps-remember-timestamps = "nil"; };
    };

    deft = {
      enable = true;
      after = [ "org-roam" ];
      custom = {
        deft-recursive = "t";
        deft-use-filter-string-for-filename = "t";
        deft-default-extension = ''"org"'';
        deft-directory = "org-roam-directory";
      };
      general = [''
        (:states 'normal
         "${leaderKey} rd"  'deft)
      ''];
    };

    # Does not exist on emacs-overlay.
    delve = {
      enable = false;
      after = [ "org-roam" ];
    };

    tex-mode = {
      enable = true;
      hook = [
        "(LaTeX-mode . prettify-symbols-mode)"
        "(LaTeX-mode . TeX-fold-mode)"
        "(LaTeX-mode . latex-preview-pane-mode)"
      ];
      custom = {
        TeX-auto-save = "t";
        TeX-parse-self = "t";
      };
    };

    # TODO: I get an error that tex cannot be loaded. Related to the other todo?
    tex = {
      enable = false;
      # TODO: This was needed when downloading it with straight. Do I still need to do this?
      # init = "(require 'texmathp)";
    };

    # TODO: Enable again
    cdlatex = {
      enable = true;
      after = [ "tex" ];
      custom = {
        cdlatex-math-modify-prefix = "?'";
        cdlatex-math-symbol-prefix = "?§";
        cdlatex-math-modify-alist = '''((?a "\\mathbb" nil t nil nil))'';
        cdlatex-env-alist = ''
          '(("theorem" "\\begin{theorem}\nAUTOLABEL\n?\n\\end{theorem}\n" nil))'';
        cdlatex-command-alist = ''
          '(("thr" "Insert theorem env" "" cdlatex-environment ("theorem") t nil))'';
      };
      general = [''
        (:keymaps 'cdlatex-mode-map
         "C-c e" 'cdlatex-environment
         "'" 'cdlatex-math-modify
         "§" 'cdlatex-math-symbol)
      ''];
    };

    saveplace = {
      enable = true;
      custom = { save-place-mode = "t"; };
    };

    savehist = {
      enable = true;
      custom = { savehist-mode = "t"; };
    };

    super-save = {
      enable = true;
      hook = [ "(find-file . (lambda () (setq buffer-save-without-query t)))" ];
      custom = { super-save-mode = "t"; };
    };

    persistent-scratch = {
      enable = true;
      custom = {
        persistent-scratch-backup-directory = ''
          (concat (file-name-as-directory no-littering-var-directory) "persistent-scratch-backups")'';
        persistent-scratch-autosave-mode = "t";
      };
      config = "(persistent-scratch--auto-restore)";
    };

    term = {
      enable = true;
      # TODO: Should I make "zsh" into a Nix variable?
      custom = { explicit-shell-file-name = ''"zsh"''; };
    };

    # TODO: This package is marked as broken. What should I do with it?
    eterm-256color = {
      enable = false;
      hook = [ "(term-mode . eterm-256color-mode)" ];
    };

    hide-mode-line = {
      enable = true;
      hook = [ "(dashboard-after-initialize . hide-mode-line-mode)" ];
    };

    dashboard = {
      enable = true;
      custom = {
        dashboard-startup-banner = "'logo";
        dashboard-center-content = "t";
        dashboard-set-heading-icons = "t";
        dashboard-set-file-icons = "t";
        dashboard-projects-backend = "'project-el";
        dashboard-items = ''
          '((recents  . 10)
            (bookmarks . 5)
            (projects . 5)
            (agenda . 5))
        '';
      };
      config = "(dashboard-setup-startup-hook)";
    };

    beacon = {
      enable = true;
      custom = {
        beacon-blink-duration = "0.5";
        beacon-mode = "t";
      };
    };

    all-the-icons = {
      enable = true;
      extraPackages = [ pkgs.emacs-all-the-icons-fonts ];
    };

    all-the-icons-dired = {
      enable = true;
      after = [ "dired" ];
      hook = [ "(dired-mode . all-the-icons-dired-mode)" ];
    };

    dired = {
      enable = true;
      general = [ ''("C-M-d" 'dired-jump)'' ];
    };

    dired-hacks-utils = {
      enable = true;
      custom = { dired-utils-format-information-line-mode = "t"; };
    };

    bufler = {
      enable = true;
      custom = { bufler-workspace-mode = "t"; };
    };

    # TODO: With dired-single I can give dired a buffer name it always keeps.
    # Is this something useful for my workflow?
    dired-single = {
      enable = true;
      after = [ "dired" ];
      general = [''
        (:states 'normal
         :keymaps 'dired-mode-map
         "h" 'dired-single-up-directory
         ;; I like going down directories like this, but not if
         ;; I accidentally open the file in another buffer.
         ;; TODO: Can I run dired-single-buffer only for directories?
         "l" 'dired-single-buffer)
      ''];
    };

    # Most of the time I do not want to change or see my dotfiles.
    # Seeing them should be a keypress away though, so as to not
    # have too much friction.
    dired-hide-dotfiles = {
      enable = true;
      after = [ "dired" ];
      hook = [ "(dired-mode . dired-hide-dotfiles-mode)" ];
      general = [''
        (:states 'normal
         :keymaps 'dired-mode-map
         "H" 'dired-hide-dotfiles-mode)
      ''];
    };

    # IDEA: Can I already view images inline with dired?
    # If not, should I set up image-dired?
    dired-open = {
      enable = true;
      after = [ "dired" ];
      custom = {
        dired-open-extensions = ''
          '(("png" . "feh") ("mkv" . "mpv"))
        '';
      };
    };

    dired-rainbow = {
      enable = true;
      after = [ "dired" ];
      config = ''
        ;; TODO: There is a lot to potentially fix with these colourings.
        ;; For example, why is .el under compiled instead of interpreted?
        ;; Nonetheless, it is a good start.
        (dired-rainbow-define-chmod
         directory "#6cb2eb"
         "d.*")
        (dired-rainbow-define
         html "#eb5286"
         ("css" "less" "sass" "scss" "htm"
          "html" "jhtm" "mht" "eml" "mustache"
          "xhtml"))
        (dired-rainbow-define
         xml "#f2d024"
         ("xml" "xsd" "xsl" "xslt" "wsdl"
          "bib" "json" "msg" "pgn" "rss"
          "yaml" "yml" "rdata" "conf"))
        (dired-rainbow-define
         document "#9561e2"
         ("docm" "doc" "docx" "odb" "odt"
          "pdb" "pdf" "ps" "rtf" "djvu"
          "epub" "odp" "ppt" "pptx"))
        (dired-rainbow-define
         markdown "#ffed4a"
         ("org" "etx" "info" "markdown" "md"
          "mkd" "nfo" "pod" "rst" "tex"
          "textfile" "txt"))
        (dired-rainbow-define
         database "#6574cd"
         ("xlsx" "xls" "csv" "accdb" "db"
          "mdb" "sqlite" "nc"))
        (dired-rainbow-define
         media "#de751f"
         ("mp3" "mp4" "MP3" "MP4" "avi"
          "mpeg" "mpg" "flv" "ogg" "mov"
          "mid" "midi" "wav" "aiff" "flac"))
        (dired-rainbow-define
         image "#f66d9b"
         ("tiff" "tif" "cdr" "gif" "ico"
          "jpeg" "jpg" "png" "psd" "eps"
          "svg"))
        (dired-rainbow-define
         log "#c17d11"
         ("log"))
        (dired-rainbow-define
         shell "#f6993f"
         ("awk" "bash" "bat" "sed" "sh"
          "zsh" "vim"))
        (dired-rainbow-define
         interpreted "#38c172"
         ("py" "ipynb" "rb" "pl" "t"
          "msql" "mysql" "pgsql" "sql" "r"
          "clj" "cljs" "scala" "js" "nix"))
        (dired-rainbow-define
         compiled "#4dc0b5"
         ("asm" "cl" "lisp" "el" "c"
          "h" "c++" "h++" "hpp" "hxx"
          "m" "cc" "cs" "cp" "cpp"
          "go" "f" "for" "ftn" "f90"
          "f95" "f03" "f08" "s" "rs"
          "hi" "hs" "pyc" ".java"))
        (dired-rainbow-define
         executable "#8cc4ff"
         ("exe" "msi"))
        (dired-rainbow-define
         compressed "#51d88a"
         ("7z" "zip" "bz2" "tgz" "txz"
          "gz" "xz" "z" "Z" "jar"
          "war" "ear" "rar" "sar" "xpi"
          "apk" "xz" "tar"))
        (dired-rainbow-define
         packaged "#faad63"
         ("deb" "rpm" "apk" "jad" "jar"
          "cab" "pak" "pk3" "vdf" "vpk"
          "bsp"))
        (dired-rainbow-define
         encrypted "#ffed4a"
         ("gpg" "pgp" "asc" "bfe" "enc"
          "signature" "sig" "p12" "pem"))
        (dired-rainbow-define
         fonts "#6cb2eb"
         ("afm" "fon" "fnt" "pfb" "pfm"
          "ttf" "otf"))
        (dired-rainbow-define
         partition "#e3342f"
         ("dmg" "iso" "bin" "nrg" "qcow"
          "toast" "vcd" "vmdk" "bak"))
        (dired-rainbow-define
         vc "#0074d9"
         ("git" "gitignore" "gitattributes" "gitmodules"))
        (dired-rainbow-define-chmod
         executable-unix "#38c172"
         "-.*x.*")
      '';
    };

    dired-collapse = {
      enable = true;
      after = [ "dired" ];
      custom = { dired-collapse-mode = "t"; };
    };

    dired-ranger = {
      enable = true;
      general = [''
        (:states 'normal
         :keymaps 'dired-mode-map
         "y" 'dired-ranger-copy
         "p" 'dired-ranger-paste
         ;; IDEA: How should I bind `dired-ranger-move'? Is "X" the best binding?
         "X" 'dired-ranger-move)
      ''];
    };

    treemacs = {
      enable = true;
      after = [ "solaire-mode" ];
    };

    daemons = { enable = true; };

    zoom = {
      enable = true;
      custom = {
        zoom-size = "'(0.618 . 0.618)";
        zoom-mode = "t";
      };
    };

    # TODO: Apparently I can also use font-awesome. Let's give that a try.
    mode-icons = {
      enable = true;
      custom = {
        mode-icons-show-mode-name = "t";
        mode-icons-mode = "t";
      };
    };

    doom-themes = {
      enable = true;
      custom = { doom-themes-padded-modeline = "t"; };
      config = "(load-theme 'doom-vibrant t)";
    };

    doom-modeline = {
      enable = true;
      custom = {
        doom-modeline-minor-modes = "t";
        doom-modeline-vcs-max-length = "24";
        doom-modeline-mode = "t";
      };
    };

    minions = {
      enable = true;
      custom = { minions-mode = "t"; };
    };

    dimmer = {
      enable = true;
      custom = {
        dimmer-fraction = "0.35";
        dimmer-mode = "t";
      };
      config = ''
        (dimmer-configure-company-box)
        (dimmer-configure-magit)
        (dimmer-configure-org)
        (dimmer-configure-which-key)
        (dimmer-configure-posframe)
      '';
    };

    solaire-mode = {
      enable = true;
      hook = [ "(dashboard-after-initialize . turn-off-solaire-mode)" ];
      custom = { solaire-global-mode = "t"; };
    };

    magit = {
      enable = true;
      custom = {
        magit-display-buffer-function =
          "#'magit-display-buffer-same-window-except-diff-v1";
        vc-follow-symlinks = "t";
      };
      general = [''
        (:states 'normal
         "${leaderKey} g"  '(:ignore t :which-key "git")
         "${leaderKey} gs" 'magit-status)
      ''];
    };

    hl-todo = {
      enable = true;
      custom = {
        hl-todo-keyword-faces = ''
          '(("TODO" . "#cc9393")
            ("TODOC" . "#afd8af")
            ("BUG" . "#d0bf8f")
            ("IDEA" . "#7cb8bb"))
        '';
        global-hl-todo-mode = "t";
      };
    };

    magit-todos = {
      enable = true;
      after = [ "hl-todo" ];
      custom = {
        magit-todos-branch-list = "nil";
        magit-todos-mode = "t";
      };
    };

    # TODO: I get an error "failed to define diff-hl-dired-mode". Why?
    # TODO: I skipped setting the custom faces for now. How can I do that with emacs-init?
    diff-hl = {
      enable = false;
      hook = [ "(dired-mode . diff-hl-dired-mode)" ];
      custom = {
        # I prefer to use background colours instead.
        diff-hl-margin-symbols-alist = ''
          '((insert . " ")
            (delete . " ")
            (change . " ")
            (unknown . "?")
            (ignored . "i"))
        '';
        # This mode will instantly show changes instead of only after saving the file.
        # I like the immediate feedback better. Especially because if I am using super
        # save mode, I should not have to think about saving at all.
        diff-hl-flydiff-mode = "t";
        # TODOC: What difference does this mode actually make? The help was not that clear.
        diff-hl-margin-mode = "t";
        global-diff-hl-mode = "t";
      };
    };
  };
}
