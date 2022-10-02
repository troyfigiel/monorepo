{
  imports = [
    ./editing.nix
    ./eglot.nix
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
    };
  };

  home.persistence."/nix/persist/home/troy" = {
    directories = [ ".emacs.d/eln-cache" ];
    files = [ ".emacs.d/org-roam.db" ];
  };
}
