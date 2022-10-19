;;; -*- lexical-binding: t -*-

(defvar band-aid-projects-dir "~/projects/")

(defun band-aid-parse-executable (bin)
  (unless (executable-find bin)
    (message (format "Binary %s could not be found!" bin))))

;; TODO: These prefix keybindings do not work in Dired buffers. Why not?
(defvar tf-keybindings/fast-prefix "<f9>"
  "Fast prefix.")

(defvar tf-keybindings/extra-prefix "<f8>"
  "Extra prefix.")

(defvar tf-keybindings/shortcut-prefix "<f7>"
  "Shortcut prefix.")

(defvar tf-core//shortcut-key nil
  "This is the shortcut key.")

(defun tf-core/redefine-shortcut ()
  (interactive)
  (setq tf-core//shortcut-key (string (read-key "Set the shortcut key: ")))
  (define-key key-translation-map
    (kbd tf-keybindings/shortcut-prefix)
    (kbd (concat tf-keybindings/extra-prefix tf-core//shortcut-key))))

(require 'band-aid-git)
(require 'band-aid-org-roam)
(require 'band-aid-scratch)
(require 'band-aid-whitespace)

(provide 'band-aid)
