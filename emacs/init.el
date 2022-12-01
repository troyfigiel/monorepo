(defun hm/reduce-gc ()
  "Reduce the frequency of garbage collection."
  (setq gc-cons-threshold most-positive-fixnum
	gc-cons-percentage 0.6))

(defun hm/restore-gc ()
  "Restore the frequency of garbage collection."
  (setq gc-cons-threshold 16777216
	gc-cons-percentage 0.1))

;; Make GC more rare during init, while minibuffer is active, and
;; when shutting down. In the latter two cases we try doing the
;; reduction early in the hook.
(hm/reduce-gc)
(add-hook 'minibuffer-setup-hook #'hm/reduce-gc -50)
(add-hook 'kill-emacs-hook #'hm/reduce-gc -50)

;; But make it more regular after startup and after closing minibuffer.
(add-hook 'emacs-startup-hook #'hm/restore-gc)
(add-hook 'minibuffer-exit-hook #'hm/restore-gc)

;; Avoid unnecessary regexp matching while loading .el files.
(defvar hm/file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)

(defun hm/restore-file-name-handler-alist ()
  "Restores the file-name-handler-alist variable."
  (setq file-name-handler-alist hm/file-name-handler-alist)
  (makunbound 'hm/file-name-handler-alist))

(add-hook 'emacs-startup-hook #'hm/restore-file-name-handler-alist)

(setq package-enable-at-startup nil)

;; Avoid expensive frame resizing. Inspired by Doom Emacs.
(setq frame-inhibit-implied-resize t)

(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 10)
(menu-bar-mode -1)

(add-to-list 'default-frame-alist '(alpha 90 . 90))
(setq custom-file null-device)
(setq sentence-end-double-space nil)
(setq visible-bell t)
(column-number-mode 1)
(setq initial-scratch-message "")


(eval-when-compile
  (require 'use-package)
  (setq use-package-verbose t))

(use-package evil
  :ensure
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  :custom
  (evil-want-C-u-scroll t)
  (evil-want-minibuffer t)
  (evil-undo-system 'undo-redo)
  (evil-disable-insert-state-bindings t)
  :config
  (evil-mode 1))

(use-package evil-collection
  :ensure
  :config
  (evil-collection-init))

(use-package general
  :ensure
  :config
  (general-evil-setup t)
  (general-auto-unbind-keys))

(use-package no-littering
  :ensure
  :config
  (setq auto-save-file-name-transforms
	`((".*" ,(no-littering-expand-var-file-name "auto-save/") t))))

(use-package all-the-icons
  :ensure)

(use-package all-the-icons-dired
  :ensure
  :after all-the-icons
  :hook (dired-mode . all-the-icons-dired-mode))

(use-package apheleia
  :ensure
  :hook (after-init . apheleia-global-mode ))

(use-package avy
  :ensure
  :general ("C-<" #'avy-goto-char-timer
	    "M-<" #'avy-pop-mark)
  :custom (avy-timeout-seconds 0.25)
  :config
  (defun avy-action-embark (pt)
    (unwind-protect
	(save-excursion
	  (goto-char pt)
	  (embark-act))
      (select-window
       (cdr (ring-ref avy-ring 0))))
    t)
  (setf (alist-get ?\C-, avy-dispatch-alist) 'avy-action-embark))

(use-package cdlatex
  :ensure
  :after tex
  :general (:keymaps 'cdlatex-mode-map
		     "C-c e" 'cdlatex-environment
		     "'" 'cdlatex-math-modify
		     "§" 'cdlatex-math-symbol)

  :custom
  (cdlatex-command-alist '(("thr" "Insert theorem env" "" cdlatex-environment ("theorem") t nil)))
  (cdlatex-env-alist '(("theorem" "\\begin{theorem}\nAUTOLABEL\n?\n\\end{theorem}\n" nil))i
  (cdlatex-math-modify-alist '((?a "\\mathbb" nil t nil nil)))
  (cdlatex-math-modify-prefix ?')))

(use-package company-terraform :ensure)

(use-package consult
  :ensure
  :general (:keymaps '(override embark-general-map)
		     "C-s" 'consult-line
		     "C-x b" 'consult-buffer
		     "C-x C-f" 'consult-find
		     "C-x C-r" 'consult-ripgrep)
  :custom
  (consult-async-min-input 2)
  (consult-project-function nil))

(use-package consult-dir
  :ensure
  :after consult
  :general (:keymaps 'override
		     "C-x C-d" #'consult-dir)
  :custom (consult-dir-shadow-filenames nil)
  :config
  (defun consult-dir--tramp-docker-hosts ()
    "Get a list of hosts from docker."
    (when (require 'docker-tramp nil t)
      (let ((hosts)
	    (docker-tramp-use-names t))
	(dolist (cand (docker-tramp--parse-running-containers))
	  (let ((user (unless (string-empty-p (car cand))
			(concat (car cand) "@")))
		(host (car (cdr cand))))
	    (push (concat "/docker:" user host ":/") hosts)))
	hosts)))

  (defvar consult-dir--source-tramp-docker
    `(:name     "Docker"
		:narrow   ?d
		:category file
		:face     consult-file
		:history  file-name-history
		:items    ,#'consult-dir--tramp-docker-hosts)
    "Docker candidate source for `consult-dir'.")

  ;; (add-to-list 'consult-dir-sources 'consult-dir--source-tramp-ssh t)
  (add-to-list 'consult-dir-sources 'consult-dir--source-tramp-docker t))

(use-package consult-eglot :ensure)

(use-package consult-flymake :ensure consult)

;; TODO: Add the Citar package? How malleable and fitting is it in the
;; whole Vertico, Embark, Consult, etc. environment?
(use-package consult-notes
  :ensure
  :after (consult denote))

(use-package csv-mode
  :ensure
  :hook (csv-mode . csv-align-mode)
  :hook (csv-mode . csv-guess-set-separator))

(use-package dashboard
  :ensure
  :custom
  (dashboard-banner-logo-title nil)
  (dashboard-bookmarks-show-base nil)
  (dashboard-center-content t)
  (dashboard-footer "")
  (dashboard-footer-icon nil)
  (dashboard-footer-messages nil)
  (dashboard-items '((bookmarks . 10)
		     (projects . 10)))
  (dashboard-projects-backend 'project-el)
  (dashboard-set-file-icons nil)
  (dashboard-set-heading-icons t)
  (dashboard-set-init-info nil)
  (dashboard-startup-banner nil)
  :config (dashboard-setup-startup-hook))

(use-package denote
  :ensure
  :hook (dired-mode . denote-dired-mode)
  :general (:keymaps 'dired-mode-map
		     "C-c n r" 'denote-dired-rename-marked-files)
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
  :hook (prog-mode . diff-hl-mode)
  :hook (dired-mode . diff-hl-dired-mode)
  :custom
  (diff-hl-margin-symbols-alist
   '((insert . " ")
     (delete . " ")
     (change . " ")
     (unknown . "?")
     (ignored . "i")))
  :config
  (diff-hl-flydiff-mode 1))

(use-package dired
  :hook (dired-mode . dired-hide-details-mode)
  :hook (dired-mode . dired-omit-mode)
  :general (:keymaps 'dired-mode-map
		     "M-+" 'dired-create-empty-file)
  :custom
  (dired-hide-details-hide-symlink-targets nil)
  ;; This hides dotfiles by default.
  (dired-omit-files "^\\.")
  :config
  (setq dired-listing-switches
	"-Ahl --group-directories-first --time-style=long-iso"))

(use-package dired-rsync
  :ensure
  :general (:states 'normal
		    :keymaps 'dired-mode-map
		    "s" 'dired-rsync))

;; TODO: This has the same problem as other packages. Once I use general, the autoloading does not work anymore.
;; dired-subtree = {
;;   enable = true;
;;   custom = {
;;     dired-subtree-use-backgrounds = "nil";
;;     dired-subtree-line-prefix = "   ";
;;   };
;;   general = [''
;;     (:states 'normal
;;      :keymaps 'dired-mode-map
;;      "* s" 'dired-subtree-mark-subtree)
;;   ''];
;; };

(use-package direnv
  :ensure
  :hook (after-init . direnv-mode))

(use-package docker
  :ensure
  :general (:prefix "C-c" "d" 'docker))

(use-package docker-compose-mode :ensure)

(use-package docker-tramp
  :ensure
  :custom (tramp-verbose 6))

(use-package dockerfile-mode :ensure)

(use-package doom-modeline
  :ensure
  :hook (after-init . doom-modeline-mode)
  :custom
  (display-time-24hr-format t)
  (display-time-day-and-date t)
  (display-time-default-load-average nil)
  (doom-modeline-hud t)
  :config
  (display-time-mode 1)
  (display-battery-mode 1))

(use-package doom-themes
  :ensure
  :config (load-theme 'doom-one t))

(use-package eglot
  :ensure
  :hook (nix-mode . eglot-ensure)
  :hook (python-mode . eglot-ensure)
  :hook (sql-mode . eglot-ensure)
  :hook (terraform-mode . eglot-ensure)
  :general (:prefix "C-c"
		    "e" '(:ignore t :which-key "IDE")
		    "ed" #'eglot-find-declaration
		    "er" #'eglot-rename)

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
  :general (:keymaps 'override
		     "C-," #'embark-act
		     "C-h b" #'embark-bindings)
  :custom
  (embark-confirm-act-all nil)
  (embark-help-key (kbd "?"))
  (embark-indicators '(embark--vertico-indicator embark-minimal-indicator embark-highlight-indicator embark-isearch-highlight-indicator)))

(use-package embark-consult
  :ensure
  :after (consult embark)
  :hook (embark-collect-mode . consult-preview-at-point-mode))

(use-package eshell
  :general (:keymaps 'eshell-mode-map
		     :states 'insert
		     "C-r" 'consult-history)
  :custom
  (eshell-banner-message "")
  (eshell-cp-overwrite-files nil)
  (eshell-mv-overwrite-files nil))

(use-package evil
  :ensure
  :general (:states 'motion
		    "j" 'evil-next-visual-line
		    "k" 'evil-previous-visual-line)

  :config
  (evil-set-initial-state 'messages-buffer-mode 'normal))

(use-package flymake
  :ensure
  :general (:prefix "C-c"
		    "ec" 'consult-flymake
		    "ef" 'flymake-show-buffer-diagnostics
		    "en" 'flymake-goto-next-error
		    "ep" 'flymake-goto-prev-error))

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
  :general (:keymaps 'override
		     :prefix "C-h"
		     "C-h" 'helpful-at-point
		     "c" 'helpful-command
		     "f" 'helpful-function
		     "k" 'helpful-key
		     "m" 'helpful-mode
		     "o" 'helpful-symbol
		     "v" 'helpful-variable))

(use-package hl-todo
  :ensure
  :hook (after-init . global-hl-todo-mode)
  :custom
  (hl-todo-keyword-faces '(("TODO" . "#dd9393"))))

(use-package linum
  :hook (prog-mode . linum-mode))

(use-package magit
  :ensure
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1)
  (transient-show-popup nil)
  (vc-follow-symlinks t))

(use-package magit-todos
  :ensure
  :after (hl-todo)
  :hook (global-hl-todo-mode . magit-todos-mode)
  :custom
  (magit-todos-branch-list nil))

(use-package marginalia
  :ensure
  :hook (after-init . marginalia-mode))

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

  ;; TODO: Create a simple binding for previewing the entire buffer in
  ;; LaTeX
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
  (push '("conf-unix" . conf-unix) org-src-lang-modes))

(use-package org-indent
  :hook (org-mode . org-indent-mode))

(use-package org-modern
  :ensure
  :hook (after-init . global-org-modern-mode))

(use-package org-remark
  :ensure
  :general (:prefix "C-c"
		    "km" 'org-remark-mark
		    "ko" 'org-remark-open
		    "kn" 'org-remark-view-next
		    "kp" 'org-remark-view-prev
		    "kd" 'org-remark-delete)
  :custom
  (org-remark-notes-file-name ".marginalia.org")
  :config
  (org-remark-global-tracking-mode 1))

(use-package org-roam
  :ensure
  :after org
  :general (:prefix "C-c"
		    "rb"  'org-roam-buffer-toggle
		    "rf" 'org-roam-node-find
		    "ri" 'org-roam-node-insert
		    "rd"  '(:ignore t :which-key "dailies")
		    "rdc" 'org-roam-dailies-capture-today
		    "rdf" 'org-roam-dailies-find-date
		    ;; "rd" 'org-roam-node-random
		    "ra"  '(:ignore t :which-key "alias")
		    "ra"  '(:ignore t :which-key "add")
		    "raa" 'org-roam-alias-add
		    "rar" 'org-roam-ref-add
		    "rat" 'org-roam-tag-add
		    "rr"  '(:ignore t :which-key "remove")
		    "rra" 'org-roam-alias-remove
		    "rrr" 'org-roam-ref-remove
		    "rrt" 'org-roam-tag-remove)
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
  :config
  ;; TODO: This seems to be necessary to open a pdf file with
  ;; pdf-view-mode automatically. I am not sure if this is specific to
  ;; the Nix package or also is the case on other operating systems.
  (add-to-list 'auto-mode-alist '("\\.pdf\\'" . pdf-view-mode)))

(use-package poetry
  :ensure
  :general (:prefix "C-c" "lpp" 'poetry))

(use-package popper
  :ensure
  :hook (after-init . popper-mode)
  :general
  (:keymaps 'override
	    :states '(normal insert visual)
	    "C-c c" 'popper-cycle
	    "C-c s" 'popper-toggle-latest
	    "C-c f" 'popper-toggle-type)

  :custom
  (popper-reference-buffers
   '("^\\*eshell.*\\*$" eshell-mode
     "^\\*shell.*\\*$" shell-mode
     "^\\*term.*\\*$" term-mode
     "^\\*vterm.*\\*$" vterm-mode))
  (popper-window-height 15))

(use-package popper-echo
  :ensure popper
  :hook (after-init . popper-echo-mode))

(use-package prescient
  :ensure
  :config (prescient-persist-mode 1))

(use-package python
  :ensure
  :general (:prefix "C-c"
		    "l"  '(:ignore t :which-key "languages")
		    "lp" '(:ignore t :which-key "python"))

  :custom
  (dap-python-debugger 'debugpy)
  (dap-python-executable "python3")
  (python-shell-interpreter "python3"))

(use-package pyvenv
  :ensure
  :general (:prefix "C-c"
		    "lpv"  '(:ignore t :which-key "pyvenv")
		    "lpva" 'pyvenv-activate
		    "lpvd" 'pyvenv-deactivate)
  :config (pyvenv-mode 1))

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

(use-package tex-mode
  :hook (LaTeX-mode . prettify-symbols-mode)
  :hook (LaTeX-mode . TeX-fold-mode)
  :hook (LaTeX-mode . latex-preview-pane-mode)
  :custom
  (TeX-auto-save t)
  (TeX-parse-self t))

(use-package tf-exif)

(use-package toc-org
  :ensure
  :hook (org-mode . toc-org-mode)
  :hook (markdown-mode . toc-org-mode)
  :hook (org-mode . toc-org-mode))

;; TODO: Tree-sitter works great for Nix, but for Python I get an
;; error that the language ABI is too recent. How do I fix this?
(use-package tree-sitter
  :ensure
  :hook (after-init . global-tree-sitter-mode)
  :hook (tree-sitter-after-on . tree-sitter-hl-mode))

(use-package tree-sitter-langs
  :ensure)

(use-package vertico
  :ensure
  :hook (after-init . vertico-mode)
  :custom (vertico-cycle t))

(use-package vertico-flat
  :ensure vertico
  :hook (vertico-mode . vertico-flat-mode))

(use-package visual-fill-column
  :ensure
  :hook (org-mode . visual-line-mode)
  :hook (markdown-mode . visual-line-mode)
  :hook (visual-line-mode . visual-fill-column-mode)
  :custom
  (visual-fill-column-center-text t)
  (visual-fill-column-width 99))

(use-package vterm
  :ensure)

;; TODO: Keybindings between wgrep and occur-mode are very different.
;; It might be good to uniformize them.
;; TODO: If general is included, other keybindings do not work
;; anymore. Why is that? general = ['' (:keymaps 'grep-mode-map
;; "M-RET" 'compilation-display-error) ''];
(use-package wgrep
  :ensure)

(use-package whitespace-cleanup-mode
  :ensure
  :hook (prog-mode . whitespace-cleanup-mode)
  :hook (text-mode . whitespace-cleanup-mode))

(use-package yaml-mode
  :ensure)

(use-package yaml-pro
  :ensure)

;; ace-window = {
;;   enable = true;
;;   custom = { aw-background = "nil"; };
;;   general = [''
;;     ("M-o" 'ace-window)
;;   ''];
;; };

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
