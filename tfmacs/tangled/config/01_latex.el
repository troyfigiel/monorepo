;;; -*- lexical-binding: t -*-

(use-package tex-mode
  :straight (:type built-in)
  :hook
  (LaTeX-mode . prettify-symbols-mode)
  (LaTeX-mode . TeX-fold-mode)
  (LaTeX-mode . latex-preview-pane-mode)
  :custom
  (TeX-auto-save t)
  (TeX-parse-self t))

;; The fact that straight needs to pull a different package from
;; the file that I actually need to require, comes from the
;; historical naming.
(use-package tex
  :straight auctex
  :init (require 'texmathp))

(use-package cdlatex
  :after tex
  ;; BUG: Something about this hook did not work. I do not remember what it was exactly.
  ;;:hook ((LaTeX-mode org-mode) . cdlatex-mode)
  :custom
  (cdlatex-math-modify-prefix ?')
  (cdlatex-math-symbol-prefix ?§)
  (qcdlatex-math-modify-alist
   '((?a "\\mathbb" nil t nil nil)))
  (cdlatex-env-alist
   '(("theorem" "\\begin{theorem}\nAUTOLABEL\n?\n\\end{theorem}\n" nil)))
  (cdlatex-command-alist
   '(("thr" "Insert theorem env" "" cdlatex-environment ("theorem") t nil)))
  :bind (:map cdlatex-mode-map
	 ("C-c e" . cdlatex-environment)
	 ("'" . cdlatex-math-modify)
	 ("§" . cdlatex-math-symbol)))

(provide 'config/01_latex)
