;;; -*- lexical-binding: t -*-

(use-package pinentry
  :custom (epg-pinentry-mode 'loopback)
  :config (pinentry-start))

(provide 'config/01_authentication)
