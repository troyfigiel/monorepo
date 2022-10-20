(use-package docker
  :general
  (:states 'normal
   :prefix core-keybindings-leader-key
   "d" 'docker))

(use-package dockerfile-mode)
(use-package docker-compose-mode)

(use-package terraform-mode)
(use-package company-terraform)
