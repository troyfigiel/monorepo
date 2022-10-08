{
  programs.fuse.userAllowOther = true;

  # TODO: How would this work if I have a completely new install? I would still have to activate my home environment for the first time?
  environment.loginShellInit = ''
    # Activate home-manager environment, if not already
    [ -d "$HOME/.nix-profile" ] || /nix/var/nix/profiles/per-user/$USER/home-manager/activate &> /dev/null
  '';
}
