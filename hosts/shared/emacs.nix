{ config, pkgs, ... }:

{
  home-manager.users.troy = {
    programs.emacs = {
      enable = true;
      package = pkgs.tf-emacs;
    };

    home = {
      packages = [ pkgs.emacs-all-the-icons-fonts pkgs.inconsolata ];
      persistence."/nix/persist/${config.home-manager.users.troy.home.homeDirectory}".directories =
        [ ".emacs.d/eln-cache" ".emacs.d/var" ".emacs.d/etc" ];
    };
  };
}
