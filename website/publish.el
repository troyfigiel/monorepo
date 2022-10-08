(require 'ox-hugo)
(setq org-hugo-base-dir default-directory)
(setq org-id-locations-file (concat org-hugo-base-dir ".org-id-locations"))

(defun build-notes ()
 (setq org-hugo-section "notes")
 (dolist (note (directory-files (getenv "notes") t "\.org$"))
  (find-file note)
  (org-hugo-export-wim-to-md)))

(defun build-blog ()
 (setq org-hugo-section "blog")
 (dolist (note (directory-files (getenv "blog") t "\.org$"))
  (find-file note)
  (org-hugo-export-wim-to-md)))

(defun build-all ()
 (build-notes)
 (build-blog))
