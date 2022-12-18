{
  home = import ./home.nix;
  xdg = import ./xdg.nix;

  firefox = import ./applications/firefox.nix;
  messenger = import ./applications/messenger.nix;

  background = import ./desktop/background.nix;
  dunst = import ./desktop/dunst.nix;
  i3 = import ./desktop/i3.nix;
  picom = import ./desktop/picom.nix;
  rofi = import ./desktop/rofi;

  git = import ./development/git.nix;

  emacs = import ../../emacs/module.nix;

  gpg = import ./security/gpg.nix;
  pass = import ./security/pass.nix;

  syncthing = import ./services/syncthing.nix;
}
