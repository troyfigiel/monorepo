# TODO: Add the settings for Emacs itself
# TODO: Add latex.el from my emacs.d
{
  imports = [
    ./completion.nix
    ./dashboard.nix
    ./development.nix
    ./dired.nix
    ./magit.nix
    ./popper.nix
    ./progmodes
    ./terminal.nix
    ./textmodes
    ./theme.nix
    ./window.nix
  ];

  programs.emacs.init.usePackage = {
    tf-exif = { enable = true; };

    pdf-tools = {
      enable = true;
      # TODO: This seems to be necessary to open a pdf file with pdf-view-mode automatically. I am not sure if this is specific to the Nix package or also is the case on other operating systems.
      config = ''
        (add-to-list 'auto-mode-alist '("\\.pdf\\'" . pdf-view-mode))
      '';
    };

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

    # xref = { enable = true; };

    evil = {
      enable = true;
      config = ''
        (evil-set-initial-state 'messages-buffer-mode 'normal)
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

    avy = {
      enable = true;
      custom = { avy-timeout-seconds = "0.25"; };
      general = [''
        ("C-<" #'avy-goto-char-timer
         "C->" #'avy-pop-mark)
      ''];
      config = ''
        (defun avy-action-embark (pt)
          (unwind-protect
              (save-excursion
                (goto-char pt)
                (embark-act))
            (select-window
             (cdr (ring-ref avy-ring 0))))
          t)

        (setf (alist-get ?\C-, avy-dispatch-alist) 'avy-action-embark)
      '';
    };

    super-save = {
      enable = true;
      config = ''
        (super-save-mode 1)
      '';
    };

    helpful = {
      enable = true;
      # TODO: If I press RET in an Embark export buffer, this does not bring me to helpful.
      # How do I override these functions instead? Should probably be done with `helpful-at-point` somehow.
      general = [''
        (:keymaps 'override
         :prefix "C-h"
         "C-h" 'helpful-at-point
         "c" 'helpful-command
         "f" 'helpful-function
         "k" 'helpful-key
         "m" 'helpful-mode
         "o" 'helpful-symbol
         "v" 'helpful-variable)
      ''];
    };
  };
}
