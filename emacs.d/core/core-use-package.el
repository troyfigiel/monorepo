;;; -*- lexical-binding: t -*-

(defcustom core-use-package-local-package-dir nil
  "Directory containing local packages to be loaded by use-local-package.")

;; Download use-package using straight.
(straight-use-package 'use-package)
(use-package use-package
  :straight nil
  :custom
  ;; Set up straight integration with use-package.
  (straight-use-package-by-default t)
  ;; Always force packages to load immediately.
  (use-package-always-demand t)
  ;; Show in the message buffer which packages have been configured and loaded.
  (use-package-verbose t)
  ;; For debugging purposes, turn this on and run `use-package-report`.
  (use-package-compute-statistics t))

;; Used for code that is not supposed to pull in a new package.
(defmacro use-feature (name &rest args)
  (declare (indent defun))
  `(use-package ,name :straight nil ,@args))

;; Used for code that is supposed to pull in a locally defined package.
(defmacro use-local-package (name &rest args)
  (declare (indent defun))
  `(progn
     (straight-use-package
      '(,name
	:type nil
	:local-repo ,(expand-file-name
		      (format "%s%s/" core-use-package-local-package-dir name)
		      user-emacs-directory)))
     (use-package ,name :straight nil ,@args)))

;; IDEA: There has to be a smarter way to add the font-locking. This
;; is more of a quick copy-paste hack.
(defconst core-use-package-use-feature-font-lock
  '(("(\\(use-feature\\)\\_>[ \t']*\\(\\(?:\\sw\\|\\s_\\)+\\)?"
     (1 font-lock-keyword-face)
     (2 font-lock-constant-face nil t))))

(defconst core-use-package-use-local-package-font-lock
  '(("(\\(use-local-package\\)\\_>[ \t']*\\(\\(?:\\sw\\|\\s_\\)+\\)?"
     (1 font-lock-keyword-face)
     (2 font-lock-constant-face nil t))))

(font-lock-add-keywords 'emacs-lisp-mode core-use-package-use-feature-font-lock)
(font-lock-add-keywords 'emacs-lisp-mode core-use-package-use-local-package-font-lock)

(provide 'core-use-package)
