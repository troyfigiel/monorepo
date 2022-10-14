{ impermanence, config, lib, ... }:

with lib;
let cfg = config.roles.emacs;
in {
  options.roles.emacs.enable = mkEnableOption "Emacs";

  config = mkIf cfg.enable (mkMerge [
    {
      # TODO: Do I really need this? This is slowing down my startup times?
      # services.emacs.enable = true;

      programs.emacs = {
        enable = true;
        init = {
          enable = true;
          recommendedGcSettings = true;
          usePackageVerbose = true;

          earlyInit = ''
            (scroll-bar-mode -1)
            (tool-bar-mode -1)
            (tooltip-mode -1)
            (set-fringe-mode 10)
            (menu-bar-mode -1)
          '';

          # TODO: For some reason I cannot use (require 'no-littering) in either prelude or earlyInit of the usePackage definition.
          # I am not sure why this does not work. Maybe a bug in the home-manager module? This is a work-around for now.
          prelude = ''
            (setq auto-save-file-name-transforms
             `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))
          '';

          usePackage = let
            orgRoamDirectory =
              "/home/troy/projects/private/nixos-config/org/notes";
          in {
            no-littering.enable = true;

            vertico = {
              enable = true;
              config = "(vertico-mode 1)";
            };

            orderless = {
              enable = true;
              config = ''
                (setq completion-styles '(orderless))
                (setq completion-category-defaults nil)
                (setq completion-category-overrides '((file (styles . (partial-completion)))))
                (setq orderless-matching-styles '(orderless-prefixes))
              '';
            };

            consult = { enable = true; };

            marginalia = {
              enable = true;
              config = "(marginalia-mode 1)";
            };

            embark = { enable = true; };

            embark-consult = { enable = true; };

            ace-window = {
              enable = true;
              config = ''
                (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
              '';
            };

            corfu = {
              enable = true;
              config = ''
                (setq corfu-auto t)
                (setq corfu-auto-prefix 2)
                (setq corfu-cycle t)
                (setq corfu-auto-delay 0.1)
                (global-corfu-mode 1)
              '';
            };

            prescient = {
              enable = true;
              config = "(prescient-persist-mode 1)";
            };

            which-key = {
              enable = true;
              config = "(which-key-mode 1)";
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
              hook = [
                "(text-mode . flyspell-mode)"
                "(prog-mode . flyspell-prog-mode)"
              ];
            };

            whitespace-cleanup-mode = {
              enable = true;
              hook = [ "prog-mode" "text-mode" ];
            };

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

            evil = {
              enable = true;
              config = ''
                (setq evil-want-C-u-scroll t)
                (setq evil-want-C-i-jump nil)
                (setq evil-undo-system 'undo-tree)
                (setq evil-mode-line-format nil)
                (evil-mode 1)
              '';
            };

            evil-escape = {
              enable = true;
              config = ''
                (setq evil-escape-unordered-key-sequence t)
                (setq evil-escape-key-sequence ".,")
                (setq evil-escape-delay 0.2)
                (evil-escape-mode 1)
              '';
            };

            evil-nerd-commenter = { enable = true; };

            elfeed = { enable = true; };
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
              config = ''
                (setq python-shell-interpreter "python3")
                (setq dap-python-executable "python3")
                (setq dap-python-debugger 'debugpy)
              '';
            };

            nix-mode = {
              enable = true;
              mode = [ ''"\\.nix\\'"'' ];
            };

            terraform-mode = { enable = true; };

            dockerfile-mode = { enable = true; };

            yaml-mode = { enable = true; };

            csv-mode = {
              enable = true;
              hook = [
                "(csv-mode . csv-align-mode)"
                "(csv-mode . csv-guess-set-separator)"
              ];
            };

            git-modes = {
              enable = true;
              mode = [ ''("\\.dockerignore\\'" . 'gitignore-mode)'' ];
            };

            org = {
              enable = true;
              config = ''
                ;; TODO: Create a simple binding for previewing the entire buffer in LaTeX
                ;; TODO: This should be org-cdlatex-mode, but can't get it to work.
                ;; TODO: Does this work as a custom or does it need to be a default?
                (setq org-catch-invisible-edits 'show-and-error)
                (setq org-ellipsis " …")
                (setq org-pretty-entities t)
                (setq org-hide-emphasis-markers t)
                (setq org-startup-with-latex-preview t)
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
              config = ''
                (setq line-spacing 0.2)
                (global-org-modern-mode 1)
              '';
            };

            # TODO: Does this interfere with org-modern?
            # TODO: Find out how well this works compared to the default.
            # (use-package valign
            #   :custom (valign-fancy-bar t)
            #   :hook (org-mode . valign-mode))

            org-sticky-header = {
              enable = true;
              hook = [ "(org-mode . org-sticky-header-mode)" ];
              config = ''
                (setq org-sticky-header-full-path 'full)
                (org-sticky-header-heading-start "")
              '';
            };

            toc-org = {
              enable = true;
              hook = [
                "(org-mode . toc-org-mode)"
                "(markdown-mode . toc-org-mode)"
              ];
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
              config = "(setq visual-fill-column-center-text t)";
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
              config = ''
                (setq org-roam-directory "${orgRoamDirectory}")
                (org-roam-db-autosync-enable)
                ;; TODO: This will not work as is, because there are no org templates in my repo yet.
                ;; (band-aid-org-roam-set-templates
                ;; (expand-file-name "org/templates" user-emacs-directory))
              '';
            };

            org-roam-ui = {
              enable = true;
              after = [ "org-roam" ];
              diminish = [ "org-roam-ui-mode" ];
              hook = [ "(after-init . org-roam-ui-mode)" ];
              config = ''
                (setq org-roam-ui-sync-theme t)
                (setq org-roam-ui-follow t)
                (setq org-roam-ui-update-on-save t)
                (setq org-roam-ui-open-on-start nil)
              '';
            };

            org-roam-timestamps = {
              enable = true;
              after = [ "org-roam" ];
              diminish = [ "org-roam-timestamps-mode" ];
              config = "(setq org-roam-timestamps-remember-timestamps nil)";
            };

            deft = {
              enable = true;
              after = [ "org-roam" ];
              config = ''
                (setq deft-recursive t)
                (setq deft-use-filter-string-for-filename t)
                (setq deft-default-extension "org")
                (setq deft-directory org-roam-directory)
              '';
            };

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
              hook = [
                "(find-file . (lambda () (setq buffer-save-without-query t)))"
              ];
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

            term = {
              enable = true;
              # TODO: Should I make "bash" into a Nix variable?
              config = ''(setq explicit-shell-file-name "bash")'';
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
              config = ''
                (setq dashboard-startup-banner 'logo)
                (setq dashboard-center-content t)
                (setq dashboard-set-heading-icons t)
                (setq dashboard-set-file-icons t)
                ;; It is a bit strange I have to set this to a value different from projectile.
                ;; If I don't do this and try to show projects, it will pull in projectile instead
                ;; of using project.el.
                (setq dashboard-projects-backend 'project-el)
                (setq dashboard-items
                 '((recents  . 10)
                   (bookmarks . 5)
                   (projects . 5)
                   (agenda . 5)))
                (dashboard-setup-startup-hook)
              '';
            };

            beacon = {
              enable = true;
              config = ''
                (setq beacon-blink-duration 0.5)
                (beacon-mode 1)
              '';
            };

            all-the-icons = { enable = true; };

            all-the-icons-dired = {
              enable = true;
              after = [ "dired" ];
              hook = [ "(dired-mode . all-the-icons-dired-mode)" ];
            };

            zoom = {
              enable = true;
              config = ''
                (setq zoom-size '(0.618 . 0.618))
                (zoom-mode 1)
              '';
            };

            mode-icons = {
              enable = true;
              config = ''
                (setq mode-icons-show-mode-name t)
                (mode-icons-mode 1)
              '';
            };

            doom-themes = {
              enable = true;
              config = ''
                (setq doom-themes-padded-modeline t)
                (load-theme 'doom-vibrant t)
              '';
            };

            doom-modeline = {
              enable = true;
              config = ''
                (setq doom-modeline-minor-modes t)
                (setq doom-modeline-vcs-max-length 24)
                (doom-modeline-mode 1)
              '';
            };

            minions = {
              enable = true;
              config = "(minions-mode 1)";
            };

            dimmer = {
              enable = true;
              config = ''
                (setq dimmer-fraction 0.35)
                (dimmer-mode 1)
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
              config = "(solaire-global-mode 1)";
            };

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
        };
      };
    }

    (optionalAttrs impermanence {
      home.persistence."/nix/persist/${config.home.homeDirectory}".directories =
        [ ".emacs.d/eln-cache" ".emacs.d/var" ".emacs.d/etc" ];
    })
  ]);
}
