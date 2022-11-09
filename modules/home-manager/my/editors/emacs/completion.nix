{ pkgs, ... }:

{
  programs.emacs.init.usePackage = {
    vertico = {
      enable = true;
      hook = [ "(after-init . vertico-mode)" ];
      custom = {
        vertico-count = "8";
        vertico-cycle = "t";
      };
      general = [''
        (:states 'motion
         :keymaps 'vertico-map
         "j" #'vertico-next
         "k" #'vertico-previous
         "RET" #'vertico-exit)
      ''];
    };

    orderless = {
      enable = true;
      custom = {
        completion-styles = "'(orderless)";
        completion-category-defaults = "nil";
        completion-category-overrides =
          "'((file (styles . (partial-completion))))";
        orderless-matching-styles = "'(orderless-prefixes)";
      };
    };

    # TODO: I do not get this yet. Need to figure out how this works.
    consult-dir = {
      enable = false;
      after = [ "consult" ];
      general = [''
        ("C-c C-d" #'consult-dir)
        (:keymaps 'vertico-map
         "C-c C-d" #'consult-dir
         "C-c C-j" #'consult-dir-jump-file)
      ''];
      # TODO: This requires docker-tramp to be installed. How to make the dependency explicit?
      # TODO: To get the same for SSH, I need to create a .ssh/config file containing my hosts.
      config = ''
        (defun consult-dir--tramp-docker-hosts ()
          "Get a list of hosts from docker."
          (when (require 'docker-tramp nil t)
            (let ((hosts)
                  (docker-tramp-use-names t))
              (dolist (cand (docker-tramp--parse-running-containers))
                (let ((user (unless (string-empty-p (car cand))
                                (concat (car cand) "@")))
                      (host (car (cdr cand))))
                  (push (concat "/docker:" user host ":/") hosts)))
              hosts)))

        (defvar consult-dir--source-tramp-docker
          `(:name     "Docker"
            :narrow   ?d
            :category file
            :face     consult-file
            :history  file-name-history
            :items    ,#'consult-dir--tramp-docker-hosts)
          "Docker candidate source for `consult-dir'.")

        (add-to-list 'consult-dir-sources 'consult-dir--source-tramp-ssh t)
        (add-to-list 'consult-dir-sources 'consult-dir--source-tramp-docker t)
      '';
    };

    consult = {
      enable = true;
      extraPackages = [ pkgs.ripgrep ];
      # TODO: consult-find and consult-ripgrep default to setting the project if I am in a project. This can be prevented by using the universal modifier, but that is a bit cumbersome. I should be able to use simulated keypresses to e.g. bind C-x C-f to the modified consult-find.
      general = [''
        (:keymaps 'global
         "C-s" 'consult-line
         "C-x b" 'consult-buffer
         "C-x C-f" 'consult-find
         "C-c f" 'consult-ripgrep)
      ''];
    };

    consult-notes = {
      enable = true;
      after = [ "consult" "denote" ];
    };

    wgrep = { enable = true; };

    marginalia = {
      enable = true;
      hook = [ "(after-init . marginalia-mode)" ];
    };

    # Embark replaces evil-nerd-commenter
    embark = {
      enable = true;
      custom = {
        embark-help-key = ''(kbd "?")'';
        embark-indicators =
          "'(embark--vertico-indicator embark-minimal-indicator embark-highlight-indicator embark-isearch-highlight-indicator)";
      };
      general = [''
        (:keymaps 'override
         "C-," #'embark-act
         "C-h b" #'embark-bindings)
      ''];
    };

    embark-consult = {
      enable = true;
      after = [ "consult" "embark" ];
      hook = [ "(embark-collect-mode . consult-preview-at-point-mode)" ];
    };

    corfu = {
      enable = true;
      hook = [ "(after-init . global-corfu-mode)" ];
      custom = {
        corfu-auto = "t";
        corfu-auto-prefix = "2";
        corfu-cycle = "t";
        corfu-auto-delay = "0.1";
      };
    };

    prescient = {
      enable = true;
      hook = [ "(after-init . prescient-persist-mode)" ];
    };
  };
}
