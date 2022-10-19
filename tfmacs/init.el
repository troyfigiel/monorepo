;;; -*- lexical-binding: t -*-

(add-to-list 'load-path (expand-file-name "core" user-emacs-directory))
(require 'core-use-package)

;; Setup no-littering now to avoid files scattered in my Emacs directory.
;; This has to be done before calling `init-loader-load`.
(use-package no-littering
  :custom
  ;; Auto-saved files go to var/auto-save/ of my Emacs directory.
  (auto-save-file-name-transforms
   `((".*" ,(no-littering-expand-var-file-name "auto-save/") t))))

;;; Core setup
(use-feature core-use-package
  :custom (core-use-package-local-package-dir "packages/"))

(use-feature core-literate
  :custom
  (core-literate-tangle-dir "tangled/")
  (core-literate-config-file "README.org")
  :config (core-literate-tangle-config))

(use-feature core-keybindings
  :custom (core-keybindings-leader-key "SPC"))

;;; Loading
;; IDEA: In the future init-loader should be used only for the patches
;; and for the transients. I would require each config/ module
;; separately so I have a more modular design. I am still not
;; completely sure how to best load my patches. I only want them to
;; apply after I load my config. Maybe I should do all of this with
;; requires and provides in the future instead of init-loader?
(use-package init-loader
  :init
  ;; TODO: Why do we need undo-tree here?
  (use-package undo-tree
    :custom (global-undo-tree-mode 1))
  ;; TODO: Can I pull my band-aid package in later?
  (use-local-package band-aid)
  (use-package el-patch)
  (use-package transient)
  :config
  (init-loader-load
   (expand-file-name
    "config/"
    (expand-file-name core-literate-tangle-dir user-emacs-directory))))
