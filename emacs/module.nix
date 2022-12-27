{ impermanence, config, lib, pkgs, ... }:

let inherit (lib) mkMerge optionalAttrs;
in {
  home-manager.users.troy = mkMerge [
    {
      programs.emacs = {
        enable = true;
        package = pkgs.tf-emacs;
      };

      # TODO: It works, but is not the right place for adding the package.
      # Once I move away from home-manager emacs-init, I will need to move this as well
      home.packages = with pkgs; [
        black
        dtach
        emacs-all-the-icons-fonts
        exiftool
        imagemagick
        inconsolata
        ispell
        ispell
        libvterm
        nil
        nixfmt
        nodePackages.prettier
        python3
        python3Packages.flake8
        python3Packages.jupytext
        python3Packages.python-lsp-server
        ripgrep
        rsync
        texlive.combined.scheme-full
      ];
    }

    (optionalAttrs impermanence {
      home.persistence."/nix/persist/${config.home-manager.users.troy.home.homeDirectory}".directories =
        [ ".emacs.d/eln-cache" ".emacs.d/var" ".emacs.d/etc" ];
    })
  ];
}
