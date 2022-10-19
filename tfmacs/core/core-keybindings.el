;;; -*- lexical-binding: t -*-

(defcustom core-keybindings-leader-key nil
  "Key to be used as the default prefix key for my commands.")

;; Since other packages use functions defined by evil and general, the
;; bare minimal configuration already needs to be set now.
(use-package evil
  :init
  ;; This needs to be set before requiring evil:
  ;; https://github.com/emacs-evil/evil-collection
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil))

(use-package evil-collection
  :after evil
  :config (evil-collection-init))

(use-package general
  :after evil
  :config
  (general-evil-setup t))

(provide 'core-keybindings)
