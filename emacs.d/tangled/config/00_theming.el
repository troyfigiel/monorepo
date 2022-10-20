(defvar tf/default-font-size 120)
(defvar tf/default-variable-font-size 120)

(set-face-attribute 'default nil :height tf/default-font-size)

;; Set the fixed pitch face
(set-face-attribute 'fixed-pitch nil :height tf/default-font-size)

;; Set the variable pitch face
(set-face-attribute 'variable-pitch nil :height tf/default-variable-font-size :weight 'regular)

(defvar tf/frame-transparency '(100 . 100))

(set-frame-parameter (selected-frame) 'alpha tf/frame-transparency)
(add-to-list 'default-frame-alist `(alpha . ,tf/frame-transparency))

(set-frame-parameter (selected-frame) 'fullscreen 'maximized)
(add-to-list 'default-frame-alist '(fullscreen . maximized))

(use-package hide-mode-line
  :hook (dashboard-after-initialize . hide-mode-line-mode))

(use-package dashboard
  :custom
  (dashboard-startup-banner 'logo)
  (dashboard-center-content t)
  (dashboard-set-heading-icons t)
  (dashboard-set-file-icons t)
  ;; It is a bit strange I have to set this to a value different from projectile.
  ;; If I don't do this and try to show projects, it will pull in projectile instead
  ;; of using project.el.
  (dashboard-projects-backend 'project-el)
  (dashboard-items
   '((recents  . 10)
     (bookmarks . 5)
     (projects . 5)
     (agenda . 5)))
  :config (dashboard-setup-startup-hook))

(use-package beacon
  :custom (beacon-blink-duration 0.5)
  :config (beacon-mode 1))

(use-package all-the-icons
  :unless (find-font (font-spec :name "all-the-icons"))
  :config (all-the-icons-install-fonts t))

(use-package all-the-icons-dired
  :after (all-the-icons dired)
  :hook (dired-mode . all-the-icons-dired-mode))

(use-package autorevert
  :straight (:type built-in))

;; NOTE: How can bufler and consult work together?
(use-package bufler
  :custom
  (bufler-workspace-mode 1))

(use-package zoom
  ;; Golden ratio. Just kind of looks nice.
  :custom (zoom-size '(0.618 . 0.618))
  :config (zoom-mode 1))

;; I need to add some mode-icons that are missing.
(use-package mode-icons
  :custom (mode-icons-show-mode-name t)
  :config (mode-icons-mode 1))

;; IDEA: I would like my org #+begin_src and #+end_src line to have a slightly darker colour.
;; How do I set this? Would this be superfluous with the right org-modern settings?
(use-package doom-themes
  :custom (doom-themes-padded-modeline t)
  :config (load-theme 'doom-vibrant t))

(use-package doom-modeline
  :custom
  (doom-modeline-minor-modes t)
  (doom-modeline-vcs-max-length 24)
  :config (doom-modeline-mode 1))

(use-package minions
  :custom (minions-mode t))

(use-package dimmer
  :custom
  (dimmer-fraction 0.35)
  (dimmer-mode 1)
  :config
  (dimmer-configure-company-box)
  (dimmer-configure-magit)
  (dimmer-configure-org)
  (dimmer-configure-which-key)
  (dimmer-configure-posframe))

(use-package solaire-mode
  ;; IDEA: This is not very consistent.
  ;; It is better if I change the function that determines what is a real buffer.
  ;; Buffers *dashboard*, " *ivy-posframe-buffer*"
  ;; I can set band-aid-solaire-mode-excluded-buffers and a function band-aid-solaire-mode-real-buffer-p that excludes the excluded buffers from solaire mode.
  :hook
  (dashboard-after-initialize . turn-off-solaire-mode)
  :config (solaire-global-mode 1))
