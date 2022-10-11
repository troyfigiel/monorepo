{
  imports = [
    ./completion.nix
    ./editing.nix
    ./eglot.nix
    ./evil.nix
    ./feed.nix
    ./languages.nix
    ./org.nix
    ./roam.nix
    ./scratch.nix
    ./terminal.nix
    ./theming.nix
    ./version-control.nix
  ];

  # TODO: Do I really need this? This is slowing down my startup times?
  # services.emacs.enable = true;

  programs.emacs = {
    enable = true;
    init = {
      enable = true;
      recommendedGcSettings = true;
      usePackageVerbose = true;

      earlyInit = ''
        (scroll-bar-mode -1)
        (tool-bar-mode -1)
        (tooltip-mode -1)
        (set-fringe-mode 10)
        (menu-bar-mode -1)
      '';

      # TODO: For some reason I cannot use (require 'no-littering) in either prelude or earlyInit of the usePackage definition.
      # I am not sure why this does not work. Maybe a bug in the home-manager module? This is a work-around for now.
      usePackage.no-littering.enable = true;
      prelude = ''
        (setq auto-save-file-name-transforms
         `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))
      '';
    };
  };

  home.persistence."/nix/persist/home/troy" = {
    directories = [ ".emacs.d/eln-cache" ".emacs.d/var" ".emacs.d/etc" ];
  };
}
