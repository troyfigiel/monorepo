{
  imports = [
    ./deft.nix
    ./org.nix
    ./org-roam.nix
    ./org-roam-timestamps.nix
    ./org-roam-ui.nix
  ];

  services.emacs.enable = true;

  programs.emacs = {
    enable = true;
    init = {
      enable = true;
      recommendedGcSettings = true;
      usePackageVerbose = true;
    };
  };
}
