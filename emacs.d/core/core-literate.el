;;; -*- lexical-binding: t -*-

;; IDEA: I only need this for `f-ext-p'. Can I clean up this use-package call?
(use-package f)

(defcustom core-literate-tangle-dir nil
  "Directory into which all band-aid configuration files are tangled.")

(defcustom core-literate-config-file nil
  "The path of the literate configuration file.")

(defun core-literate--add-lexical-bindings-header ()
  "If the current buffer is an elisp file, adds a lexical binding header."
  (when (f-ext-p (buffer-file-name) "el")
    (goto-char (point-min))
    (insert ";;; -*- lexical-binding: t -*-\n\n")
    (save-buffer)))

(defun core-literate--buffer-provide ()
  (file-name-sans-extension
   (file-relative-name
    (expand-file-name (buffer-file-name))
    (expand-file-name core-literate-tangle-dir user-emacs-directory))))

(defun core-literate--add-provide-footer ()
  "If the current buffer is an elisp file, adds a provide footer."
  (when (f-ext-p (buffer-file-name) "el")
    (goto-char (point-max))
    (insert (format "\n(provide '%s)" (core-literate--buffer-provide)))
    (save-buffer)))

(defun core-literate--tangle-file-to-dir (file dir)
  "Deletes and recreates DIR and tangles FILE into DIR."
  (delete-directory dir t)
  (make-directory dir)
  (org-babel-tangle-file file))

(defun core-literate-tangle-config ()
  "Tangles literate configuration file into the set tangle directory."
  (let ((default-directory user-emacs-directory))
    (core-literate--tangle-file-to-dir
     (expand-file-name core-literate-config-file)
     (expand-file-name core-literate-tangle-dir))))

(add-to-list 'load-path (expand-file-name core-literate-tangle-dir user-emacs-directory))

;; To hook into `org-babel-post-tangle`, we need to bring org-babel in scope.
;; We prefer to download the newer version of org instead of the one Emacs
;; ships with by default.
(use-package org
  :hook
  ;; Whenever we tangle elisp files, we automatically add lexical-binding
  ;; headers and provide footers.
  (org-babel-post-tangle . core-literate--add-lexical-bindings-header)
  (org-babel-post-tangle . core-literate--add-provide-footer)
  ;; We need to turn this off, because we are often changing our README file.
  ;; TODO: This does not actually work. Why not?
  :config (setq org-element-use-cache nil))

(provide 'core-literate)
