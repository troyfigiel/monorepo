{
  flake.hmModules = {
    home = import ./my/home.nix;
    xdg = import ./my/xdg.nix;

    firefox = import ./my/applications/firefox.nix;
    messenger = import ./my/applications/messenger.nix;

    alacritty = import ./my/shell/alacritty.nix;
    zsh = import ./my/shell/zsh;

    background = import ./my/desktop/background.nix;
    dunst = import ./my/desktop/dunst.nix;
    i3 = import ./my/desktop/i3.nix;
    picom = import ./my/desktop/picom.nix;
    polybar = import ./my/desktop/polybar.nix;
    rofi = import ./my/desktop/rofi;

    git = import ./my/development/git.nix;

    emacs = import ./my/editors/emacs;
    nvim = import ./my/editors/nvim.nix;
    vscode = import ./my/editors/vscode.nix;

    gpg = import ./my/security/gpg.nix;
    pass = import ./my/security/pass.nix;

    syncthing = import ./my/services/syncthing.nix;
  };
}
