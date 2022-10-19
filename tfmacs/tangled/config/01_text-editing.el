;;; -*- lexical-binding: t -*-

(use-package undo-fu)

(use-package undo-fu-session)
;; (use-package undo-fu-session
;;   :custom (global-undo-fu-session-mode 1))

(use-package vundo)

(use-package default-text-scale)

;; TODO: Figure out when we actually get ^L characters instead of line breaks.
;; Dashboard works fine, right?
(use-package page-break-lines
  :config (global-page-break-lines-mode 1))

;; IDEA: Spellchecking probably needs to be turned off in other file types as well.
;; I should think of which other ones.
;; Examples: csv
(use-package flyspell
  :straight (:type built-in)
  :hook
  (text-mode . flyspell-mode)
  (prog-mode . flyspell-prog-mode))

(provide 'config/01_text-editing)
