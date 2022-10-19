;;; -*- lexical-binding: t -*-

;; Make sure we do not get an additional asterisk if we are not using indent mode.
(el-patch-feature org-sticky-header)
(with-eval-after-load 'org-sticky-header
  (el-patch-defun org-sticky-header--indent-prefix ()
    "Return indentation prefix for heading at point.
This will do the right thing both with and without `org-indent-mode'."
    ;; Modelled after `org-indent-set-line-properties'
    (let* ((level (org-current-level))
	   (indent-mode (bound-and-true-p org-indent-mode))
	   (npre (if (<= level 1) 0
		   (+ (if indent-mode
			  (* (1- org-indent-indentation-per-level)
			     (1- level))
			0)
		      level -1)))
	   (prefix (concat (make-string npre (el-patch-splice 2 1 (if indent-mode ?\ ?*))) org-sticky-header-heading-star " ")))
      (org-add-props prefix nil 'face
		     (if org-cycle-level-faces
			 (setq org-f (nth (% (1- level) org-n-level-faces) org-level-faces))
		       (setq org-f (nth (1- (min level org-n-level-faces)) org-level-faces)))))))

(provide 'patches/01_org-sticky-header)
