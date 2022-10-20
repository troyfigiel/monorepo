(use-package evil-escape
  :custom
  (evil-escape-unordered-key-sequence t)
  ;; I prefer not to use letters, because I find it disturbs my workflow
  ;; if I accidentally bump myself out of insert mode.
  ;; However, evil-escape is very convenient if it works as expected.
  ;; Therefore, I keep the delay at 0.1 and bind it to keys that
  ;; are never used together (period and comma).
  ;; IDEA: I only use this key sequence to return back to the normal state.
  ;; Can I make that implicit? I believe evil-escape can also be used for
  ;; various other `quit' functionalities.
  (evil-escape-key-sequence ".,")
  ;; Because I rarely use the escape key sequence in combination anyway,
  ;; there is no harm in setting the delay slightly higher to avoid not
  ;; being quick enough with the key-chord.
  (evil-escape-delay 0.2)
  :config (evil-escape-mode 1))

(use-package evil
  :custom
  (evil-want-C-u-scroll t)
  (evil-want-C-i-jump nil)
  (evil-undo-system 'undo-tree)
  (evil-mode-line-format nil)
  :config (evil-mode 1)
  ;; Use visual line motions even outside of visual-line-mode buffers
  ;; TODOC: What does this do exactly?
  :general
  (:states 'motion
   "j" 'evil-next-visual-line
   "k" 'evil-previous-visual-line))

(evil-set-initial-state 'messages-buffer-mode 'normal)
(evil-set-initial-state 'dashboard-mode 'normal)

;; BUG: Sometimes comments too much. Why?
(use-package evil-nerd-commenter
  :general
  ("s-#" 'evilnc-comment-or-uncomment-lines))
