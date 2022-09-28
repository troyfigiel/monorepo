{
  imports = [
    ./hardware-configuration.nix
    ./networking
    ./security
    ./system
    ./users.nix
  ];

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.utf8";
  console.keyMap = "de";

  # TODO: The directories that are required to be persisted should be moved to the appropriate modules.
  # Here it is too unclear why I am persisting certain directories or files.
  # NOTE: The NixOS module system will actually take care of that. If an attribute is defined in multiple modules,
  # Nix will try to automatically merge these definitions. This makes it very easy to create a modular config.
  environment.persistence."/nix/persist" = {
    hideMounts = true;
    users.root = {
      home = "/root";
      directories = [ ".gnupg" ];
      files = [ ".ssh/known_hosts" ];
    };
  };

  programs.fuse.userAllowOther = true;

  # TODO: How would this work if I have a completely new install? I would still have to activate my home environment for the first time?
  environment.loginShellInit = ''
    # Activate home-manager environment, if not already
    [ -d "$HOME/.nix-profile" ] || /nix/var/nix/profiles/per-user/$USER/home-manager/activate &> /dev/null
  '';
}
