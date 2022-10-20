(use-package crux)

(use-package restart-emacs
  :general
  (:states 'normal
   :prefix core-keybindings-leader-key
   "R" 'restart-emacs))

(use-package crontab-mode
  :mode "\\.?cron\\(tab\\)?\\'")
