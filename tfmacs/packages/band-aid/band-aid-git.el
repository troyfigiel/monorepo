;;; -*- lexical-binding: t -*-

(defun band-aid-git-clone (url dir &rest args)
  (save-window-excursion
    (if (file-directory-p dir)
	(message (format "Cannot clone to %s. Directory already exists." dir))
      (shell-command
       (format "git clone %s %s %s" url dir (apply #'concat args))))))

(provide 'band-aid-git)
