;;; -*- lexical-binding: t -*-

(use-package term
  :custom
  (explicit-shell-file-name "bash"))

(use-package eterm-256color
  :hook (term-mode . eterm-256color-mode))

(use-package tldr
  ;; IDEA: I should not always have to contact GitHub for updates.
  ;; Maybe I should turn this into a transient?
  :config (tldr-update-docs))

(provide 'config/01_terminal)
