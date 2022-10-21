{
  flake.hmModules = {
    alacritty = import ./alacritty.nix;
    background = import ./background.nix;
    dunst = import ./dunst.nix;
    emacs = import ./emacs;
    firefox = import ./firefox.nix;
    git = import ./git.nix;
    gpg = import ./gpg.nix;
    i3 = import ./i3.nix;
    messenger = import ./messenger.nix;
    nvim = import ./nvim.nix;
    pass = import ./pass.nix;
    picom = import ./picom.nix;
    polybar = import ./polybar.nix;
    rofi = import ./rofi;
    syncthing = import ./syncthing.nix;
    vscode = import ./vscode.nix;
    xdg = import ./xdg.nix;
    zsh = import ./zsh;
  };
}
