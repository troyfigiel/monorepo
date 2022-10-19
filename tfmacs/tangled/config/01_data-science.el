;;; -*- lexical-binding: t -*-

(use-package yaml-mode)
(use-package yaml-pro
  :straight (:type git :host github :repo "zkry/yaml-pro"))

(use-package toml-mode)

(use-package csv-mode
  :hook
  (csv-mode . csv-align-mode)
  (csv-mode . csv-guess-set-separator))

;; IDEA: It would be nice if I can open a separate buffer in SES mode to edit
;; a dataframe. I can do this using `ein:kernel-utils-pandas-to-ses', but what
;; about more generally?
(use-package ein
  ;; Apparently this hook is necessary for undo inside ein.
  :hook (evil-local-mode . turn-on-undo-tree-mode)
  ;; I can set additional properties through ein:output-area-inlined-image-properties.
  :custom (ein:output-area-inlined-images t))

;; This comes with the very handy function `ein:kernel-utils-pandas-to-ses`.
(use-package ein-kernel-utils
  :straight (:type git :host github :repo "millejoh/ein-kernel-utils")
  :after ein
  :init
  (use-package company)
  (use-package popup))

;; IDEA: Some spreadsheet tool would be a useful addition, but is SES mode
;; the best option? I know there is also a package `cell-mode' for example.
(use-feature ses
  :hook (ses-mode . linum-mode))

(provide 'config/01_data-science)
