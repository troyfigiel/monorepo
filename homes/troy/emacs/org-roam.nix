let
  orgRoamDirectory = "/home/troy/projects/private/nixos-config/writings/notes";
in {
  programs.emacs.init.usePackage.org-roam = {
    enable = true;
    after = [ "org" ];
    config = ''
      (setq org-roam-directory ${orgRoamDirectory})
      (org-roam-db-autosync-enable)
      ;; TODO: This will not work as is, because there are no org templates in my repo yet.
      ;; (band-aid-org-roam-set-templates
      ;; (expand-file-name "org/templates" user-emacs-directory))
    '';
  };
}
