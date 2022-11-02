# TODO: Add the settings for Emacs itself
# TODO: Add latex.el from my emacs.d
{
  imports = [
    ./treemacs.nix
    ./completion.nix
    ./dired.nix
    ./magit.nix
    ./popper.nix
    ./development.nix
    ./terminal.nix
    ./theme.nix
    ./progmodes
    ./textmodes
  ];

  programs.emacs.init.usePackage = {
    # TODO: This should not be here, but for some reason I cannot use (require 'no-littering) in either prelude or earlyInit of the usePackage definition.
    # I am not sure why this does not work. Maybe a bug in the home-manager module? This is a work-around for now.
    # I think the problem is that no-littering is trying to create a directory. This error is specific to no-littering.
    no-littering = {
      enable = true;
      config = ''
        (setq auto-save-file-name-transforms
         `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))
      '';
    };

    # TODO: Not sure I would actually use this a lot.
    # ace-window = {
    #   enable = true;
    #   hook = [ "(after-init . ace-window-display-mode)" ];
    #   custom = {
    #     aw-background = "nil";
    #     aw-char-position = "nil";
    #     aw-dispatch-always = "t";
    #     aw-keys = "'(?a ?s ?d ?f ?g ?h ?j ?k ?l)";
    #   };
    #   general = [''
    #     (:states 'normal
    #      "${leaderKey} w" #'ace-window)
    #   ''];
    # };

    # default-text-scale = { enable = true; };

    # page-break-lines = {
    #   enable = false;
    #   config = "(global-page-break-lines-mode 1)";
    # };

    xref = { enable = true; };

    evil = {
      enable = true;
      config = ''
        (evil-set-initial-state 'messages-buffer-mode 'normal)
        ;; (evil-set-initial-state 'dashboard-mode 'normal)
      '';
      general = [''
        (:states 'motion
         "j" 'evil-next-visual-line
         "k" 'evil-previous-visual-line)
      ''];
    };

    # ses = {
    #   enable = true;
    #   hook = [ "(ses-mode . linum-mode)" ];
    # };

    # avy = {
    #   enable = true;
    #   # general = [ ''(:states 'motion "f" #'evil-avy-goto-char-2)'' ];
    # };

    super-save = {
      enable = true;
      hook = [
        "(find-file . (lambda () (setq buffer-save-without-query t)))"
        "(after-init . super-save-mode)"
      ];
    };

    # zoom = {
    #   enable = true;
    #   hook = [ "(after-init . zoom-mode)" ];
    #   custom = { zoom-size = "'(0.618 . 0.618)"; };
    # };
  };
}
