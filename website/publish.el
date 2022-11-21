(require 'ox-hugo)
(setq org-hugo-base-dir default-directory)
(setq org-id-locations-file (concat org-hugo-base-dir ".org-id-locations"))
(setq org-directory (file-name-as-directory (getenv "references")))

(defun build-section (section)
 (setq org-hugo-section section)
 (dolist (note (directory-files (concat org-directory section) t "\.org$"))
  (find-file note)
  (org-hugo-export-wim-to-md)))

(defun build-all ()
 (build-section "blog"))
