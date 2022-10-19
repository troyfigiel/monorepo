;;; -*- lexical-binding: t -*-

(general-define-key
 "s-b" 'consult-buffer)

(general-define-key
 "s-q" 'delete-window
 "s-u" 'winner-undo
 "s-f" 'find-file)

(general-define-key
 "s-1" 'delete-other-windows
 "s-2" 'split-window-below
 "s-3" 'split-window-right)

(general-create-definer tf/extra-keys
  :prefix tf-keybindings/extra-prefix)

(tf/extra-keys
  tf-keybindings/extra-prefix 'tf-core/redefine-shortcut)

(tf/extra-keys
  "t"  '(:ignore t :which-key "toggle")
  "td" 'toggle-debug-on-error
  "tw" 'whitespace-mode
  "tl" 'display-line-numbers-mode
  "tt" 'consult-theme)
;; Does not work yet because I removed hydras
;;"ts" '(tf/hydra-text-scale/body :which-key "tf/hydra-text-scale"))

(tf/extra-keys
  "o"   '(:ignore t :which-key "org")
  "oo"  'org-open-at-point
  "ob"  '(tf/hydra-org-babel/body :which-key "tf/hydra-org-babel"))

(tf/extra-keys
  "e"  '(:ignore t :which-key "eval")
  "eb" 'eval-buffer)

(tf/extra-keys
  :keymaps '(visual)
  "er" 'eval-region)

(tf/extra-keys
  "g"  '(:ignore t :which-key "git")
  "gt" 'git-timemachine
  "gl" 'git-link
  "gi" 'magit-init)

(general-create-definer tf/fast-keys
  :prefix tf-keybindings/fast-prefix)

(tf/fast-keys
  "c"   'evil-avy-goto-char-2
  "g"   'magit-status
  "i"   'crux-find-user-init-file
  "l"   'evil-avy-goto-line
  ;;"m" 'evil-avy-pop-mark
  ;; "s" something with scratch buffer
  "k" '(lambda () (interactive) (kill-buffer (current-buffer))))

;; (use-package helpful
;;   :bind
;;   ([remap describe-function] . counsel-describe-function)
;;   ([remap describe-command] . helpful-command)
;;   ([remap describe-variable] . counsel-describe-variable)
;;   ([remap describe-key] . helpful-key))

(define-key global-map (kbd "C-c j")
  (lambda () (interactive) (org-capture nil "jj")))

(provide 'config/02_keybindings)
