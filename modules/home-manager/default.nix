{
  flake.hmModules = {
    alacritty = import ./my/alacritty.nix;
    background = import ./my/background.nix;
    dunst = import ./my/dunst.nix;
    emacs = import ./my/emacs;
    firefox = import ./my/firefox.nix;
    git = import ./my/git.nix;
    gpg = import ./my/gpg.nix;
    i3 = import ./my/i3.nix;
    messenger = import ./my/messenger.nix;
    nvim = import ./my/nvim.nix;
    pass = import ./my/pass.nix;
    picom = import ./my/picom.nix;
    polybar = import ./my/polybar.nix;
    rofi = import ./my/rofi;
    syncthing = import ./my/syncthing.nix;
    vscode = import ./my/vscode.nix;
    xdg = import ./my/xdg.nix;
    zsh = import ./my/zsh;
  };
}
