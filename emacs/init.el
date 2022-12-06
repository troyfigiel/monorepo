(eval-when-compile
  (require 'use-package)
  (setq use-package-verbose t))
(require 'bind-key)

(use-package emacs
  :hook (prog-mode . display-line-numbers-mode)
  :custom
  (custom-file null-device)
  (display-time-24hr-format t)
  (display-time-day-and-date t)
  (display-time-default-load-average nil)
  (initial-buffer-choice t)
  (initial-scratch-message nil)
  (sentence-end-double-space nil)
  (visible-bell t)
  :config
  (add-to-list 'default-frame-alist '(alpha 90 . 90))
  ;; TODO: There should be a new alpha-background parameter in Emacs
  ;; 29. How do I set it? (add-to-list 'default-frame-alist
  ;; '(alpha-background 90))
  (column-number-mode 1)
  (display-battery-mode 1)
  (display-time-mode 1)
  (menu-bar-mode -1)
  (scroll-bar-mode -1)
  (set-fringe-mode 15)
  (tool-bar-mode -1)
  (tooltip-mode -1))

(use-package doom-themes
  :ensure
  :config (load-theme 'doom-one t))

;; TODO: doom-modeline is quite complicated whereas I do not need so
;; much functionality for my mode line. It should not be too difficult
;; to set mode-line-format myself.
(use-package doom-modeline
  :ensure
  :config (doom-modeline-mode 1))

(use-package no-littering
  :ensure
  :config
  (setq auto-save-file-name-transforms
        `((".*" ,(no-littering-expand-var-file-name "auto-save/") t))))

(use-package all-the-icons
  :ensure)

(use-package all-the-icons-dired
  :ensure
  :after (all-the-icons dired)
  :hook (dired-mode . all-the-icons-dired-mode))

(use-package apheleia
  :ensure
  :config (apheleia-global-mode 1))

(use-package avy
  :ensure
  :bind* (("C-," . avy-goto-char-timer)
          ("M-," . avy-goto-line))
  :custom (avy-timeout-seconds 0.25))

(use-package cdlatex
  :ensure
  :after tex
  :custom
  (cdlatex-command-alist '(("thr" "Insert theorem env" "" cdlatex-environment ("theorem") t nil)))
  (cdlatex-env-alist '(("theorem" "\\begin{theorem}\nAUTOLABEL\n?\n\\end{theorem}\n" nil))i
  (cdlatex-math-modify-alist '((?a "\\mathbb" nil t nil nil)))
  (cdlatex-math-modify-prefix ?')))

(use-package consult
  :ensure
  :bind*
   (("C-x b" . consult-buffer)
   ("C-c C-l" . consult-line)
   ("C-c C-f" . consult-find)
   ("C-c C-r" . consult-ripgrep)
   ("C-c C-a" . consult-global-mark))
  :custom
  (consult-async-min-input 2)
  (consult-project-function nil))

(use-package consult-dir
  :ensure
  :after consult
  :bind* ("C-x C-d" . consult-dir)
  :custom (consult-dir-shadow-filenames nil))

(use-package consult-eglot
  :ensure
  :after (consult eglot))

(use-package consult-flymake
  :ensure consult
  :after (consult flymake))

;; TODO: Add the Citar package? How malleable and fitting is it in the
;; whole Vertico, Embark, Consult, etc. environment?
(use-package consult-notes
  :ensure
  :after (consult denote))

(use-package csv-mode
  :ensure
  :hook ((csv-mode . csv-align-mode)
         (csv-mode . csv-guess-set-separator)))

(use-package denote
  :ensure
  :hook (dired-mode . denote-dired-mode)
  :bind (:map dired-mode-map
         ("C-c C-n C-r" . denote-dired-rename-marked-files))
  :custom
  (denote-link-backlinks-display-buffer-action '((display-buffer-reuse-window
                                                  display-buffer-in-side-window)
                                                 (side . left)
                                                 (slot . 99)
                                                 (window-width . 0.3)))
  :config
  (defun my-denote-split-org-subtree ()
    "Create new Denote note as an Org file using current Org subtree."
    (interactive)
    (let ((text (org-get-entry))
          (heading (org-get-heading :no-tags :no-todo :no-priority :no-comment))
          (tags (org-get-tags)))
      (delete-region (org-entry-beginning-position) (org-entry-end-position))
      (denote heading tags 'org)
      (insert text))))

(use-package detached :ensure)

(use-package diff-hl
  :ensure
  :hook ((prog-mode . diff-hl-mode)
         (dired-mode . diff-hl-dired-mode))
  :custom
  (diff-hl-margin-symbols-alist
   '((insert . " ")
     (delete . " ")
     (change . " ")
     (unknown . "?")
     (ignored . "i")))
  :config (diff-hl-flydiff-mode 1))

(use-package dired
  :hook ((dired-mode . dired-hide-details-mode)
         (dired-mode . dired-omit-mode))
  :bind (:map dired-mode-map
              ("M-+" . dired-create-empty-file)
              ("C-c C-w" . wdired-change-to-wdired-mode))
  :custom
  (dired-hide-details-hide-symlink-targets nil)
  ;; This hides dotfiles by default.
  (dired-omit-files "^\\.")
  :config
  (setq dired-listing-switches
        "-Ahl --group-directories-first --time-style=long-iso"))

(use-package dired-rsync
  :ensure
  :after dired
  :bind (:map dired-mode-map
              ("s" . dired-rsync)))

(use-package dired-subtree
  :ensure
  :after dired
  :custom
  (dired-subtree-use-backgrounds nil)
  (dired-subtree-line-prefix "   ")
  ;; TODO: Add key bindings for dired-subtree-up and maybe some other
  ;; convenience functions.
  :bind (:map dired-mode-map
              ("<tab>" . dired-subtree-toggle)
              ("* s" . dired-subtree-mark-subtree)))

(use-package direnv
  :ensure
  :config (direnv-mode 1))

(use-package docker
  :ensure
  :bind (("C-c C-d" . docker)))

(use-package docker-compose-mode :ensure)

(use-package dockerfile-mode :ensure)

(use-package eglot
  :ensure
  :hook
  ((nix-mode
    python-mode
    sql-mode
    terraform-mode) . eglot-ensure)
  :config
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
       (jedi_completion (fuzzy . t)))))))

(use-package electric
  :config (electric-pair-mode 1))

;; TODO: I am not sure what this does exactly. I think this is a
;; which-key replacement. I have to check, e.g. if I run C-c C-h or
;; C-C ? this window pops-up.prefix-help-command = "#'embark-prefix-help-command";
(use-package embark
  :ensure
  :hook (embark-collect-mode . hl-line-mode)
  :bind* (("C-." . embark-act)
          ("C-h b" . embark-bindings))
  :custom
  (embark-confirm-act-all nil)
  (embark-help-key (kbd "?"))
  (embark-indicators '(embark--vertico-indicator embark-minimal-indicator embark-highlight-indicator embark-isearch-highlight-indicator)))

(use-package embark-consult
  :ensure
  :after (consult embark)
  :hook (embark-collect-mode . consult-preview-at-point-mode))

(use-package eshell
  ;; TODO: eshell-mode-map is buggy in eshell. I need to either use
  ;; :hook or set the binding in a different way.
  ;; https://github.com/noctuid/general.el/issues/80
  :bind* (("C-c C-e" . eshell))
          ;; :map eshell-mode-map
          ;; ("C-r" . consult-history))
  :custom
  (eshell-banner-message "")
  (eshell-cp-overwrite-files nil)
  (eshell-mv-overwrite-files nil))

;; TODO: The main useful entry point is consult-flymake. Only bind
;; that one and flymake-show-buffer-diagnostics?
(use-package flymake
  :ensure)
  ;; :bind (:prefix "C-c"
  ;;		    "ec" 'consult-flymake
  ;;		    "ef" 'flymake-show-buffer-diagnostics
  ;;		    "en" 'flymake-goto-next-error
  ;;		    "ep" 'flymake-goto-prev-error))

(use-package flyspell
  :hook (prog-mode . flyspell-prog-mode)
  :hook (text-mode . flyspell-mode))

(use-package fontaine
  :ensure
  :custom
  (fontaine-presets '((default
                        :default-family "Inconsolata"
                        :default-height 140
                        :line-spacing 2)))
  :config
  (fontaine-set-preset 'default))

(use-package git-modes
  :ensure
  :mode ("\\.dockerignore\\'" . 'gitignore-mode))

;; TODO: If I press RET in an Embark export buffer, this does not
;; bring me to helpful. How do I override these functions instead?
;; Should probably be done with `helpful-at-point` somehow.
(use-package helpful
  :ensure
  :bind (("C-h C-h" . helpful-at-point)
         ("C-h c" . helpful-command)
         ("C-h f" . helpful-function)
         ("C-h k" . helpful-key)
         ("C-h m" . helpful-mode)
         ("C-h o" . helpful-symbol)
         ("C-h v" . helpful-variable)))

(use-package hl-todo
  :ensure
  :custom (hl-todo-keyword-faces '(("TODO" . "#ff2222")))
  :config (global-hl-todo-mode 1))

(use-package magit
  :ensure
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1)
  (transient-show-popup nil)
  (vc-follow-symlinks t))

(use-package magit-todos
  :ensure
  :after hl-todo
  :hook (global-hl-todo-mode . magit-todos-mode)
  :custom (magit-todos-branch-list nil))

(use-package marginalia
  :ensure
  :config (marginalia-mode 1))

(use-package nix-mode
  :ensure
  :mode "\\.nix\\'")

(use-package orderless
  :ensure
  :custom
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles . (partial-completion)))))
  (completion-styles '(orderless))
  ;; TODO: The completion style is a bit harsh. If I type "con grep" I
  ;; also want to match consult-ripgrep. But "con con" should not
  ;; match anything consult-related. The second part should match a
  ;; different word. How do I achieve this?
  (orderless-matching-styles '(orderless-prefixes)))

(use-package org
  :ensure
  :custom
  (org-catch-invisible-edits 'show-and-error)
  (org-ellipsis " …")
  (org-hide-emphasis-markers t)
  (org-pretty-entities t)
  (org-startup-folded 'content)
  :config
  (set-face-attribute 'org-level-1 nil :height 1.3)
  (set-face-attribute 'org-level-2 nil :height 1.2)
  (set-face-attribute 'org-document-title nil :height 1.4)
  (set-face-attribute 'org-document-info nil :height 1.2)
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
  (push '("conf-unix" . conf-unix) org-src-lang-modes))

(use-package org-indent
  :after org
  :hook (org-mode . org-indent-mode))

(use-package org-modern
  :ensure
  :after org
  :config (global-org-modern-mode 1))

(use-package org-remark
  :ensure
  :after org
  :bind (("C-c C-k C-m" . org-remark-mark)
         ("C-c C-k C-o" . org-remark-open)
         ("C-c C-k C-n" . org-remark-view-next)
         ("C-c C-k C-p" . org-remark-view-prev)
         ("C-c C-k C-d" . org-remark-delete))
  :custom (org-remark-notes-file-name ".marginalia.org")
  :config (org-remark-global-tracking-mode 1))

(use-package org-roam
  :ensure
  :after org
  :custom
  (org-roam-completion-everywhere t)
  (org-roam-directory (expand-file-name "/home/troy/projects/private/monorepo/references/notes"))
  :config (org-roam-db-autosync-enable)

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
   (expand-file-name "/home/troy/projects/private/monorepo/org/templates")))

(use-package org-transclusion :ensure)

(use-package pdf-tools
  :ensure
  :mode ("\\.pdf\\'" . pdf-view-mode))

(use-package popper
  :ensure
  :demand t
  :bind* (("C-#" . popper-toggle-latest)
          ("M-#" . popper-cycle)
          ("C-M-#" . popper-toggle-type))
  :custom
  (popper-reference-buffers
   '("^\\*eshell.*\\*$" eshell-mod
     "^\\*shell.*\\*$" shell-mode
     "^\\*term.*\\*$" term-mode
     "^\\*vterm.*\\*$" vterm-mode))
  (popper-window-height 15)
  :config
  (popper-mode 1)
  (popper-echo-mode 1))

(use-package prescient
  :ensure
  :config (prescient-persist-mode 1))

(use-package python
  :ensure
  :custom
  (dap-python-debugger 'debugpy)
  (dap-python-executable "python3")
  (python-shell-interpreter "python3"))

;; (use-package pyvenv
;;   :ensure
;;   :config (pyvenv-mode 1))

(use-package rainbow-delimiters
  :ensure
  :hook (prog-mode . rainbow-delimiters-mode))

;; TODO: I should bind a key to recentf-cleanup. Sometimes there are
;; numerous recent files pointing to non-existing paths, such as when
;; happens when Docker containers get removed.
(use-package recentf
  :init
  ;; It is important to turn recentf-auto-cleanup to never *before*
  ;; setting turning on recentf-mode. By default recentf will run an
  ;; auto-cleanup when turning on recentf-mode.
  (setq recentf-auto-cleanup 'never)
  :custom
  ;; TODO: What does the recentf-max-menu-items option exactly change?
  ;; (recentf-max-menu-items 50)
  (recentf-auto-cleanup 'never)
  (recentf-max-saved-items 200)
  :config
  (recentf-mode 1)
  (run-at-time nil 300 'recentf-save-list))

(use-package super-save
  :ensure
  :config (super-save-mode 1))

(use-package terraform-mode :ensure)

(use-package tf-exif)

(use-package toc-org
  :ensure
  :hook ((org-mode markdown-mode) . toc-org-mode))

;; TODO: Tree-sitter works great for Nix, but for Python I get an
;; error that the language ABI is too recent. How do I fix this?
(use-package tree-sitter
  :ensure
  :hook (tree-sitter-after-on . tree-sitter-hl-mode)
  :config (global-tree-sitter-mode 1))

(use-package tree-sitter-langs
  :ensure)

(use-package expand-region
  :ensure
  :bind (("C-+" . er/expand-region)))

(use-package vertico
  :ensure
  :custom (vertico-cycle t)
  :config
  (vertico-mode 1)
  (vertico-flat-mode 1))

(use-package visual-fill-column
  :ensure
  :hook
  ((org-mode . visual-line-mode)
   (markdown-mode . visual-line-mode)
   (visual-line-mode . visual-fill-column-mode))
  :custom
  (visual-fill-column-center-text t)
  (visual-fill-column-width 99))

(use-package vterm
  :ensure
  :bind* (("C-c C-t" . vterm)))

(use-package wgrep
  :ensure)

(use-package whitespace-cleanup-mode
  :ensure
  :hook ((prog-mode text-mode) . whitespace-cleanup-mode))

(use-package yaml-mode
  :ensure)

(use-package yaml-pro
  :ensure)

(use-package ace-window
  :ensure
  :custom
  (aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
  (aw-background nil)
  (aw-dispatch-always t)
  :bind (("M-o" . ace-window)))

(use-package which-key
  :ensure
  :config (which-key-mode 1))

;; TODO: Does this interfere with org-modern?
;; TODO: Find out how well this works compared to the default.
;; (use-package valign
;;   :custom (valign-fancy-bar t)
;;   :hook (org-mode . valign-mode))

;; ox-hugo = { enable = true; };

;; ses = {
;;   enable = true;
;;   hook = [ "(ses-mode . linum-mode)" ];
;; };

;; default-text-scale = { enable = true; };
;; xref = { enable = true; };
