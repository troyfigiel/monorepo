;;; -*- lexical-binding: t -*-

(use-package scratch)

;; I am not too happy about the workflow.
;; I would much rather be able to create multiple scratch files
;; that automatically get saved
(defun band-aid-scratch (mode)
  (interactive (list (scratch--buffer-querymode)))
  (persistent-scratch-new-backup)
  (persistent-scratch-save)
  (let ((buf (get-buffer "*scratch*")))
    (with-current-buffer buf
      (erase-buffer)
      (funcall mode))
    (pop-to-buffer buf)))

(defun band-aid-search-persistent-scratch-backups (pattern)
  (interactive (list (read-string "Regex pattern: ")))
  (grep (format
	 "grep --color=auto -nH --null -e %s -R %s"
	 pattern
	 persistent-scratch-backup-directory)))

(provide 'band-aid-scratch)
