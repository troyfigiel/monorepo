;;; -*- lexical-binding: t -*-

(use-package consult-eglot)
;; TODOC: What about ctags and etags? Can I use them for code completions?

;; All the tools in here require external dependencies:
;; - Language servers
;; - Formatters

;; I do not use eglot for formatting, instead deferring to apheleia which runs
;; my formatter asynchronously.
(use-package apheleia
  :init
  (band-aid-parse-executable "black")
  ;; (band-aid-parse-executable "prettier")
  :config (apheleia-global-mode 1)
  :general
  (:states 'normal
   :prefix core-keybindings-leader-key
   "ta"))

(use-package eglot
  :init
  (band-aid-parse-executable "pylsp")
  (band-aid-parse-executable "flake8")
  :hook
  ;; IDEA: These need to be separate sexps,
  ;; because they will ultimately be separate noweb styled code blocks.
  (python-mode . eglot-ensure)
  (terraform-mode . eglot-ensure)
  (nix-mode . eglot-ensure)
  (sql-mode . eglot-ensure)
  ;; IDEA: If eglot messes up some of my settings, I can use
  ;; `eglot-stay-out-of'. For example, (eglot-stay-out-of '(completion-styles))
  :config
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
  :general
  (:states 'normal
   :prefix core-keybindings-leader-key
   "e" '(:ignore t :which-key "IDE")
   "ed" #'eglot-find-declaration
   "er" #'eglot-rename))

(use-package flymake
  :general
  (:states 'normal
   :prefix core-keybindings-leader-key
   "ec" #'consult-flymake
   "ef" #'flymake-show-buffer-diagnostics
   "en" #'flymake-goto-next-error
   "ep" #'flymake-goto-prev-error))

;; TODO: Add keybindings for going to definition etc.
(use-package xref)

(provide 'config/01_eglot)
