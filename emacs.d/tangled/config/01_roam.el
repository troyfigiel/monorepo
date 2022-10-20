(use-package delve
  :straight (:type git :host github :repo "publicimageltd/delve")
  :after org-roam)

(use-package org-roam
  ;; Note that we cannot currently use 01_org as a feature, because config is not in our load path.
  ;; Do we need this?
  :after org
  :custom
  ;; TODO: Try to create an overlay so I can use [[id:...]] and the title is always up to date
  ;; TODO: Make a hydra out of some of the roam commands
  (org-roam-directory
   (expand-file-name "org/notes" user-emacs-directory))
  (org-roam-completion-everywhere t)
  :config
  (band-aid-git-clone
   "git@gitlab.com:troy.figiel/zettelkasten.git"
   org-roam-directory)
  (org-roam-setup)
  (band-aid-org-roam-set-templates
   (expand-file-name "org/templates" user-emacs-directory))
  :general
  (:states 'normal
   :prefix core-keybindings-leader-key
   "r"   '(:ignore t :which-key "org-roam")
   "rb"  'org-roam-buffer-toggle
   "rn"  '(:ignore t :which-key "node")
   "rnf" 'org-roam-node-find
   "rni" 'org-roam-node-insert
   "rnr" 'org-roam-node-random
   "ra"  '(:ignore t :which-key "alias")
   "raa" 'org-roam-alias-add
   "rar" 'org-roam-alias-remove
   "rr"  '(:ignore t :which-key "ref")
   "rra" 'org-roam-ref-add
   "rrr" 'org-roam-ref-remove
   "rt"  '(:ignore t :which-key "tag")
   "rta" 'org-roam-tag-add
   "rtr" 'org-roam-tag-remove
   "ra"  '(:ignore t :which-key "add")))
;; (use-package org-roam-bibtex)

(use-package org-roam-ui
  :after org-roam
  :diminish
  :custom
  (org-roam-ui-sync-theme t)
  (org-roam-ui-follow t)
  (org-roam-ui-update-on-save t)
  (org-roam-ui-open-on-start nil)
  :hook (after-init . org-roam-ui-mode))

(use-package org-roam-timestamps
  :after org-roam
  :diminish
  :custom
  (org-roam-timestamps-remember-timestamps nil)
  :hook (after-init . org-roam-timestamps-mode))

(use-package deft
  :after org-roam
  :custom
  ;; Need to figure out how deft works precisely
  (deft-recursive t)
  (deft-use-filter-string-for-filename t)
  (deft-default-extension "org")
  (deft-directory org-roam-directory)
  :general
  (:states 'normal
   :prefix core-keybindings-leader-key
   "rd"  'deft))
