;;; -*- lexical-binding: t -*-

;; TODO: Create a simple binding for previewing the entire buffer in LaTeX
;; TODO: This should be org-cdlatex-mode, but can't get it to work.
(use-package org
  :custom
  ;; TODO: Does this work as a custom or does it need to be a default?
  (org-catch-invisible-edits 'show-and-error)
  (org-ellipsis " …")
  (org-pretty-entities t)
  (org-hide-emphasis-markers t)
  (org-startup-with-latex-preview t)
  :config
  (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
  (add-to-list 'org-structure-template-alist '("py" . "src python"))
  (add-to-list 'org-structure-template-alist '("sh" . "src shell"))
  (add-to-list 'org-structure-template-alist '("r" . "src R"))
  (add-to-list 'org-structure-template-alist '("sh" . "src shell"))
  (add-to-list 'org-structure-template-alist '("sq" . "src sql"))
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (python . t)
     (shell . t)
     (R . t)
     (sql . t)))
  (push '("conf-unix" . conf-unix) org-src-lang-modes))

(use-package org-modern
  :custom (line-spacing 0.2)
  :config (global-org-modern-mode 1))

;; TODO: Does this interfere with org-modern?
;; TODO: Find out how well this works compared to the default.
;; (use-package valign
;;   :custom (valign-fancy-bar t)
;;   :hook (org-mode . valign-mode))

(use-feature patches/01_org-sticky-header :after org-sticky-header)

(use-package org-sticky-header
  :custom
  (org-sticky-header-full-path 'full)
  (org-sticky-header-heading-star "")
  :hook (org-mode . org-sticky-header-mode))

(use-package toc-org
  :hook
  (org-mode . toc-org-mode)
  (markdown-mode . toc-org-mode))

;; BUG: This does not work together well with `diff-hl', because it ends
;; up creating a very large coloured block instead of a small fringe whenever
;; I changed, add or delete something to a git controlled file.
;; IDEA: Can I add `olivetti' and have it work together well with `visual-fill-column'
;; or is it a replacement of that package?
(use-package visual-fill-column
  ;; What does visual-line-mode do? When does it trigger?
  :hook (visual-line-mode . visual-fill-column-mode)
  :custom (visual-fill-column-center-text t))

(use-package org-appear
  :hook (org-mode . org-appear-mode))

;; TODO: Does this interfere with org-modern?
;; (use-package org-superstar
;;   :hook (org-mode . org-superstar-mode)
;;   :custom
;;   ;; org-superstar-cycle-headline-bullets: By default we cycle through the list.
;;   ;; org-superstar-leading-bullet: Also by default, the bullets are connected
;;   ;; by . to the left margin.
;;   ;; I can also add a lot of customization to TODOs.
;;   ;; org-superstar-item-bullet-alist also has good defaults.
;;   (org-superstar-headline-bullets-list '("◉" "○")))

(provide 'config/01_org)
