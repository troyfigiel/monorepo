;; IDEA: I should set up pretty-magit. This integrates well with conventional commits.
(use-package magit
  :custom
  (magit-display-buffer-function
   #'magit-display-buffer-same-window-except-diff-v1)
  (vc-follow-symlinks t)
  :general
  ;; BUG: These keybindings do not work in dired. Why not? Wrong keymap?
  (:states 'normal
   :prefix core-keybindings-leader-key
   "g"  '(:ignore t :which-key "git")
   "gs" 'magit-status))

(use-package hl-todo
  :custom
  (hl-todo-keyword-faces
   '(("TODO" . "#cc9393")
     ("TODOC" . "#afd8af")
     ("BUG" . "#d0bf8f")
     ("IDEA" . "#7cb8bb")))
  :config (global-hl-todo-mode 1))

;; BUG: My magit-todos disappears in the nix-shell. Why does this happen?
;; Am I missing a required package?
;; IDEA: Unfortunately, magit-todos calls the sections "TODOs" and this
;; value is hard coded throughout the code. It is possible to fix this
;; using el-patch but it is too much effort for now.
;; BUG: Even if I remove ".git/" from the magit-todos-exclude-glob
;; it seems not to find the TODOs anyway. Can I figure out why?
(use-package magit-todos
  :after hl-todo
  ;; BUG: It does not seem like magit-todos-branch-list works flawlessly. For example,
  ;; it does not seem to take into account the `magit-todos-keyword' suffix variable
  ;; and greps for all TODOs instead.
  :custom (magit-todos-branch-list nil)
  ;; `magit-todos-max-items' determines when a section should automatically collapse.
  ;; The default setting of 10 is a reasonable number.
  ;; (magit-todos-max-items 10)
  ;; TODOC: I do not know what this variable actually does.
  ;; I leave it set to the default of 20.
  ;; (magit-todos-auto-group-items 20)
  :config
  ;; I do not need to see the TODOs in the README,
  ;; because they already show up in my config directory.
  ;; Having them show up in my config directory gives a clearer
  ;; semantic separation as well.
  ;; This is why I have added the README file to .dir-locals.el.
  ;; It also means I need to add the README file to my safe-local-variable-values.
  (add-to-list 'safe-local-variable-values `(magit-todos-exclude-globs . (,core-literate-config-file)))
  (magit-todos-mode 1))

;; IDEA: What is diff-hl-magit? Should I add a hook for that?
(use-package diff-hl
  :hook (dired-mode . diff-hl-dired-mode)
  :custom
  (diff-hl-margin-symbols-alist
   ;; I prefer to use background colours instead.
   '((insert . " ")
     (delete . " ")
     (change . " ")
     (unknown . "?")
     (ignored . "i")))
  ;; This mode will instantly show changes instead of only after saving the file.
  ;; I like the immediate feedback better. Especially because if I am using super
  ;; save mode, I should not have to think about saving at all.
  (diff-hl-flydiff-mode 1)
  ;; TODOC: What difference does this mode actually make? The help was not that clear.
  (diff-hl-margin-mode 1)
  (global-diff-hl-mode 1)
  :custom-face
  ;; IDEA: I am setting both the foreground and background colour now.
  ;; What is the difference and do we need to set both?
  (diff-hl-insert ((t (:foreground "#7bc275" :background "#7bc275"))))
  (diff-hl-delete ((t (:foreground "#ff665c" :background "#ff665c"))))
  (diff-hl-change ((t (:foreground "#fcce7b" :background "#fcce7b")))))

;; BUG: Both of these packages have some problems upon loading.
;;(use-package git-timemachine)
;;(use-package git-undo)

(use-package forge
  :custom
  ;; Set maximum open issues shown in forge to 200.
  ;; Function forge-toggle-closed-visibility changes the sign of -200.
  (forge-topic-list-limit '(200 . -200))
  (forge-alist
   '(("gitlab.justdice-ops.io"
      "gitlab.justdice-ops.io/api/v4"
      "gitlab.justdice-ops.io"
      forge-gitlab-repository)
     ("github.com"
      "api.github.com"
      "github.com"
      forge-github-repository)
     ("gitlab.com"
      "gitlab.com/api/v4"
      "gitlab.com"
      forge-gitlab-repository)))
  :config
  ;; This will need to be set before magit! Does not work otherwise.
  (setq forge-add-default-bindings nil))

(use-package git-modes
  :mode ("\\.dockerignore\\'" . 'gitignore-mode))
