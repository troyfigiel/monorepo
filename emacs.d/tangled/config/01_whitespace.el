(use-package whitespace-cleanup-mode
  :hook (prog-mode text-mode))

;; BUG: The dim grey background does show up in commit messages. I need to exclude these.
;; BUG: The same is true for ein.
(use-feature band-aid
  :custom-face
  ;; IDEA: Not the nicest, but better than red. Can I make it a bullet instead?
  (trailing-whitespace ((t :background "dim grey")))
  :hook
  ((prog-mode text-mode) . band-aid-show-trailing-whitespace))
