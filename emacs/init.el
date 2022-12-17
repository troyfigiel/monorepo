(eval-when-compile
  (require 'use-package)
  (setq use-package-verbose t))
(require 'bind-key)

(defun tf-isearch-jump-to-match-start ()
  (when (and isearch-forward
	     isearch-other-end
	     ;; Do not jump to the start of the search if the search is quit.
	     (not isearch-mode-end-hook-quit))
    (goto-char isearch-other-end)))

(use-package emacs
  :hook ((prog-mode . display-line-numbers-mode)
	 (isearch-mode-end . tf-isearch-jump-to-match-start))
  :bind* ("C-x C-b" . ibuffer)
  :custom
  (custom-file null-device)
  (display-time-24hr-format t)
  (display-time-day-and-date t)
  (display-time-default-load-average nil)
  (fill-column 99)
  (initial-buffer-choice "~")
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

;; TODO: Workflow? In a team you will probably end up having to use Jupyter notebooks and
;; JupyterLab. If I just need to make some small changes to notebooks, I can probably get away with
;; code-cells. When working by myself, org-mode is a great option as well with org-babel.
(use-package code-cells
  ;; TODO: Would it make sense to use code-cells for every language with a REPL? I quite like the
  ;; working style.
  :ensure
  :hook (python-mode . code-cells-mode-maybe))

(use-package jupyter
  :ensure
  :custom (jupyter-repl-echo-eval-p t))

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
  :after dired
  :hook (dired-mode . all-the-icons-dired-mode))

(use-package apheleia
  :ensure
  :config
  (add-to-list 'apheleia-mode-alist '(emacs-lisp-mode . lisp-indent))
  (apheleia-global-mode 1))

(use-package avy
  :ensure
  :bind* (("C-#" . avy-goto-char-timer)
          ("M-#" . avy-goto-line))
  :custom (avy-timeout-seconds 0.25))

(use-package cdlatex
  :ensure
  :after tex
  :custom
  (cdlatex-command-alist '(("thr" "Insert theorem env" "" cdlatex-environment ("theorem") t nil)))
  (cdlatex-env-alist
   '(("theorem" "\\begin{theorem}\nAUTOLABEL\n?\n\\end{theorem}\n" nil)))
  (cdlatex-math-modify-alist '((?a "\\mathbb" nil t nil nil)))
  (cdlatex-math-modify-prefix ?'))

(use-package consult
  :ensure
  ;; TODO: Do I want to bind consult-kmacro?
  :bind*
  (("C-x b" . consult-buffer)
   ("M-y" . consult-yank-pop)
   ;; TODO: I do not use this yet, but maybe in the future for
   ;; debugging with tracebacks?
   ("M-g g" . consult-goto-line)
   ("M-g M-g" . consult-goto-line)
   ("C-c C-l" . consult-line)
   ("C-x p f" . consult-find)
   ("C-x p g" . consult-ripgrep)
   ("C-x p b" . consult-project-buffer)
   ("C-c C-a" . consult-global-mark)
   ;; TODO: How often do I use consult-isearch-history anyway? This
   ;; overwrites the isearch-edit-string functionality.
   :map isearch-mode-map
   ("M-e" . consult-isearch-history)
   ;; TODO: How often do I use consult-history in the minibuffer?
   :map minibuffer-local-map
   ("M-r" . consult-history)
   ("M-s" . consult-history))
  :custom
  (consult-async-min-input 2))

(use-package consult-dir
  :ensure
  :bind* ("C-x C-d" . consult-dir)
  :custom (consult-dir-shadow-filenames nil))

(use-package consult-eglot
  :ensure
  :after eglot)

(use-package consult-flymake
  :ensure consult
  :after flymake)

;; TODO: Add the Citar package? How malleable and fitting is it in the
;; whole Vertico, Embark, Consult, etc. environment?
(use-package consult-notes
  :ensure)

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
  (denote-link-backlinks-display-buffer-action
   '((display-buffer-reuse-window
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

(use-package detached
  :ensure)

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
  ;; TODO: Should I enable some of these bindings in wdired-mode-map?
  :bind (:map dired-mode-map
              ("<tab>" . dired-subtree-toggle)
              ("* s" . dired-subtree-mark-subtree)
	      ("C-M-u" . dired-subtree-up)
	      ("C-M-p" . dired-subtree-previous-sibling)
	      ("C-M-n" . dired-subtree-next-sibling))
  :custom
  (dired-subtree-use-backgrounds nil)
  (dired-subtree-line-prefix "   "))

(use-package direnv
  :ensure
  :config (direnv-mode 1))

(use-package docker
  :ensure
  :bind (("C-c C-d" . docker)))

(use-package docker-compose-mode
  :ensure)

(use-package dockerfile-mode
  :ensure)

(use-package eglot
  :hook (python-mode . eglot-ensure))

(use-package electric
  :config (electric-pair-mode 1))

;; TODO: I am not sure what this does exactly. I think this is a
;; which-key replacement. I have to check, e.g. if I run C-c C-h or
;; C-C ? this window pops-up.prefix-help-command = "#'embark-prefix-help-command";
(use-package embark
  :ensure
  :hook (embark-collect-mode . hl-line-mode)
  :bind* (("C-." . embark-act)
	  ("M-." . embark-dwim)
          ("C-h b" . embark-bindings))
  :custom
  (embark-confirm-act-all nil)
  (embark-help-key (kbd "?"))
  (embark-indicators
   '(embark--vertico-indicator
     embark-minimal-indicator
     embark-highlight-indicator
     embark-isearch-highlight-indicator)))

(use-package embark-consult
  :ensure
  :after embark
  :hook (embark-collect-mode . consult-preview-at-point-mode))

;; TODO: Currently there is a bug in tramp-container.el which does
;; not seem to exist in docker-tramp.el, causing the wrong path to
;; be searched when eshell is in the container. In the future, I
;; need to update and check if the bug persists or send the bug
;; report to upstream (which I need to check how to do exactly).
(use-package eshell
  ;; TODO: eshell-mode-map is buggy in eshell. I need to either use
  ;; :hook or set the binding in a different way.
  ;; https://github.com/noctuid/general.el/issues/80

  ;; :bind* (("C-c C-e" . eshell))
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
  (fontaine-presets
   '((default
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
  ;; TODO: The completion style is a bit harsh. If I type "con grep"
  ;; I also want to match consult-ripgrep. But "con con" should not
  ;; match anything consult-related. The second part should match a
  ;; different word. How do I achieve this?
  (orderless-matching-styles '(orderless-prefixes)))

(use-package org
  :hook (org-mode . visual-line-mode)
  :config
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

(use-package org-transclusion :ensure)

(use-package pdf-tools
  :ensure
  :mode ("\\.pdf\\'" . pdf-view-mode))

(use-package python
  :ensure
  :custom
  (dap-python-debugger 'debugpy)
  (dap-python-executable "python3")
  (python-shell-interpreter "python3"))

(use-package pyvenv
  :ensure
  :config (pyvenv-mode 1))

(use-package rainbow-delimiters
  :ensure
  :hook (prog-mode . rainbow-delimiters-mode))

;; TODO: I should bind a key to recentf-cleanup. Sometimes there are
;; numerous recent files pointing to non-existing paths, such as when
;; happens when Docker containers get removed.
;; (use-package recentf
;;   :init
;;   ;; It is important to turn recentf-auto-cleanup to never *before*
;;   ;; setting turning on recentf-mode. By default recentf will run an
;;   ;; auto-cleanup when turning on recentf-mode.
;;   (setq recentf-auto-cleanup 'never)
;;   :custom
;;   ;; TODO: What does the recentf-max-menu-items option exactly change?
;;   ;; (recentf-max-menu-items 50)
;;   (recentf-auto-cleanup 'never)
;;   (recentf-max-saved-items 200)
;;   :config
;;   (recentf-mode 1)
;;   (run-at-time nil 300 'recentf-save-list))

(use-package super-save
  :ensure
  :config (super-save-mode 1))

(use-package tab-bar
  :bind ("C-x t s" . tab-bar-select-tab-by-name)
  :custom
  (tab-bar-show nil)
  :config
  (tab-bar-mode 1)
  (tab-bar-history-mode 1))

(use-package terraform-mode :ensure)

(use-package tf-exif
  :ensure tf-lisp)

;; TODO: Tree-sitter works great for Nix, but for Python I get an
;; error that the language ABI is too recent. How do I fix this?
(use-package tree-sitter
  :hook (tree-sitter-after-on . tree-sitter-hl-mode)
  :config (global-tree-sitter-mode 1))

(use-package tree-sitter-langs
  :ensure)

(use-package expand-region
  :ensure
  :bind ("C-+" . er/expand-region))

(use-package vertico
  :ensure
  :custom (vertico-cycle t)
  :config
  (vertico-mode 1)
  (vertico-flat-mode 1))

(use-package visual-fill-column
  :ensure
  :hook (visual-line-mode . visual-fill-column-mode))

(use-package vterm
  :ensure
  :bind* ("C-c C-t" . vterm))

(use-package wgrep
  :ensure)

(use-package whitespace-cleanup-mode
  :ensure
  :hook ((prog-mode text-mode) . whitespace-cleanup-mode))

(use-package yaml-mode
  :ensure)

(use-package ace-window
  :ensure
  :bind ("M-o" . ace-window)
  :custom
  (aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
  (aw-background nil)
  (aw-dispatch-always t)
  :config
  (advice-add #'aw--switch-buffer :override #'consult-buffer))

;; `ace-window' is able to dispatch to `transpose-frame', but does not
;; depend on it by default.
(use-package transpose-frame
  :ensure
  :after ace-window)

(use-package which-key
  :ensure
  :config (which-key-mode 1))

