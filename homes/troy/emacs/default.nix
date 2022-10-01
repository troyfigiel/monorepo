{
  imports = [
    ./deft
    ./org
    ./org-roam
    ./org-roam-timestamps
    ./org-roam-ui
  ];

  services.emacs.enable = true;

  programs.emacs = {
    enable = true;
    init = {
      enable = true;
      recommendedGcSettings = true;
      usePackageVerbose = true;
      usePackage = { nix-mode = { enable = true; }; };
    };
  };
}
