{
  home = import ./home.nix;
  firefox = import ./firefox.nix;
  git = import ./git.nix;
  gpg = import ./gpg.nix;
  messenger = import ./messenger.nix;
  pass = import ./pass.nix;
  xdg = import ./xdg.nix;

  dunst = import ./desktop/dunst.nix;
  i3 = import ./desktop/i3.nix;
  picom = import ./desktop/picom.nix;
  rofi = import ./desktop/rofi;

  emacs = import ../../emacs/module.nix;
}
