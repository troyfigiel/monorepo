;;; -*- lexical-binding: t -*-

(defun asdf-reshim ()
  (interactive)
  (shell-command (asdf--command "reshim")))

(provide 'patches/01_asdf-reshim)
