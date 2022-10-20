(use-package transient)

(transient-define-prefix asdf ()
  "asdf menu."
  [["Packages"
    ("c" "current" asdf-current)
    ("i" "install" asdf-install)
    ("r" "reshim" asdf-reshim)]
   ["Plugins"
    ("a" "add" asdf-plugin-add)
    ("l" "list" asdf-plugin-list)]])
