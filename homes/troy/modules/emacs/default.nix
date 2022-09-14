{
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
