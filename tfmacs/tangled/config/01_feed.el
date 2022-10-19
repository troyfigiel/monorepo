;;; -*- lexical-binding: t -*-

(use-package elfeed
  :general
  (:states 'normal
   :prefix core-keybindings-leader-key
   "f" 'elfeed))

(use-package elfeed-org
  :after elfeed)
;;   :custom (rmh-elfeed-org-files (list "~/org/private/feeds.org"))
;;   :config (elfeed-org))

(use-package elfeed-tube
  :after elfeed)

(provide 'config/01_feed)
