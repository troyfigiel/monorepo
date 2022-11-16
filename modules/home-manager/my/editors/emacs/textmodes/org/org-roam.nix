let leaderKey = "C-c";
in {
  programs.emacs.init.usePackage = {
    # TODO: I have to be careful with the diredfl package. It currently does not work nicely together with denote: https://lists.sr.ht/~protesilaos/denote/%3Cm0tu6q6bg0.fsf%40disroot.org%3E
    # TODO: The denote filenaming convention is quite useful. I might stick with that for other things as well.
    denote = {
      enable = true;
      custom = {
        # TODO: Do I use this if I will be using embark?
        denote-link-backlinks-display-buffer-action = ''
          '((display-buffer-reuse-window
             display-buffer-in-side-window)
            (side . left)
            (slot . 99)
            (window-width . 0.3))
        '';
      };
      # TODO: This is a very useful function to split off org subtrees into their own notes.
      config = ''
        (defun my-denote-split-org-subtree ()
          "Create new Denote note as an Org file using current Org subtree."
          (interactive)
          (let ((text (org-get-entry))
                (heading (org-get-heading :no-tags :no-todo :no-priority :no-comment))
                (tags (org-get-tags)))
            (delete-region (org-entry-beginning-position) (org-entry-end-position))
            (denote heading tags 'org)
            (insert text)))
      '';
    };

    org-roam = {
      enable = true;
      after = [ "org" ];
      custom = {
        # TODO: We should also extract the org/templates directory as a separate parameter.
        org-roam-directory = ''
          (expand-file-name "/home/troy/projects/private/monorepo/references/notes")
        '';
        org-roam-completion-everywhere = "t";
      };
      config = ''
        (org-roam-db-autosync-enable)

        (defun band-aid-org-roam-capture-template (keybinding name)
          `(,keybinding
            ,name
            plain
            (file ,(expand-file-name (concat name ".org")))
            :if-new (file "%<%Y%m%d%H%M%S>.org")
            :unnarrowed t))

        (defun band-aid-org-roam-set-templates (template-directory)
          (let ((default-directory template-directory))
            (setq org-roam-capture-templates
            (list (band-aid-org-roam-capture-template "d" "default")
            (band-aid-org-roam-capture-template "i" "index")
            (band-aid-org-roam-capture-template "f" "facts")
            (band-aid-org-roam-capture-template "b" "inbox")
            (band-aid-org-roam-capture-template "a" "appendix")))))

        (band-aid-org-roam-set-templates
          (expand-file-name "/home/troy/projects/private/monorepo/org/templates"))
      '';
      general = [''
        (:prefix "${leaderKey}"
         "rb"  'org-roam-buffer-toggle
         "rf" 'org-roam-node-find
         "ri" 'org-roam-node-insert
         "rd"  '(:ignore t :which-key "dailies")
         "rdc" 'org-roam-dailies-capture-today
         "rdf" 'org-roam-dailies-find-date
         ;; "rd" 'org-roam-node-random
         "ra"  '(:ignore t :which-key "alias")
         "ra"  '(:ignore t :which-key "add")
         "raa" 'org-roam-alias-add
         "rar" 'org-roam-ref-add
         "rat" 'org-roam-tag-add
         "rr"  '(:ignore t :which-key "remove")
         "rra" 'org-roam-alias-remove
         "rrr" 'org-roam-ref-remove
         "rrt" 'org-roam-tag-remove)
      ''];
    };
  };
}
