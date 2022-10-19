;;; -*- lexical-binding: t -*-

(defun band-aid-org-roam-capture-template (keybinding name)
  `(,keybinding
    ,name
    plain
    (file ,(expand-file-name (concat name ".org")))
    :if-new (file "%<%Y%m%d%H%M%S>.org")
    :unnarrowed t))

(defun band-aid-org-roam-set-templates (template-directory)
  (let ((default-directory template-directory))
    (setq org-roam-capture-templates
	  (list (band-aid-org-roam-capture-template "d" "default")
		(band-aid-org-roam-capture-template "i" "index")
		(band-aid-org-roam-capture-template "f" "facts")
		(band-aid-org-roam-capture-template "b" "inbox")
		(band-aid-org-roam-capture-template "a" "appendix")))))

(provide 'band-aid-org-roam)
