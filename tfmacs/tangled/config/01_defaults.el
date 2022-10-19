;;; -*- lexical-binding: t -*-

(use-feature emacs
  :custom
  (mode-line-percent-position nil)
  ;; No custom file. Complete reproducibility.
  (custom-file null-device)
  ;; By default emacs requires two spaces after a period to end a sentence. This is an old default that interferes with evil.
  (sentence-end-double-space nil)
  ;; Without the visible bell, hitting the edges of a file will make an annoying noise.
  ;; TODOC: Is this really the case?
  (visible-bell t)
  :config (column-number-mode 1)
  :general ("s-x" 'keyboard-escape-quit))

(use-feature patches/01_lisp)

(provide 'config/01_defaults)
