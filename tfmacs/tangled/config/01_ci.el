;;; -*- lexical-binding: t -*-

(use-package gitlab-ci-mode
  ;; I either put my gitlab-ci files in .gitlab-ci.yml or inside the .gitlab folder.
  :mode "\\.gitlab/.*\\.ya?ml")

(provide 'config/01_ci)
