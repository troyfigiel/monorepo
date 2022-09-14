{ config, lib, pkgs, ... }:

{
  imports =
    [ ./hardware-configuration.nix ./networking ./security ./system ./users ];

  nix = {
    package = pkgs.nixFlakes;
    settings = {
      # Until my own binary cache is set up, let's turn it off.
      # substituters = [ "http://192.168.178.37:10106/nix-binary-cache/" ];
      # trusted-public-keys =
      #  [ "minio.local-1:ZTYgVFeAYCoDqu0HppKRQRy54es8EZ5LVAmZQJO/VDA=" ];
      # trusted-users = [ "troy" ];
      auto-optimise-store = true;
    };

    gc = {
      automatic = true;
      dates = "weekly";
    };

    extraOptions = ''
      experimental-features = nix-command flakes
      min-free = ${toString (3 * 1024 * 1024 * 1024)}
      max-free = ${toString (10 * 1024 * 1024 * 1024)}
    '';
  };

  # TODO: The directories that are required to be persisted should be moved to the appropriate modules.
  # Here it is too unclear why I am persisting certain directories or files.
  # NOTE: The NixOS module system will actually take care of that. If an attribute is defined in multiple modules,
  # Nix will try to automatically merge these definitions. This makes it very easy to create a modular config.
  environment.persistence."/nix/persist" = {
    hideMounts = true;

    users.troy = {
      directories = [
        # Signal stores its data in the .config directory.
        # See: https://github.com/signalapp/Signal-Desktop/issues/4975
        ".aws"
        ".mc"
        ".config/Signal"
        ".config/nix"
        ".config/whatsapp-for-linux"
        ".cache/whatsapp-for-linux"
        ".cache/mozilla"
        ".cache/nix-index"
        ".mozilla"
        ".wallpapers"
        ".steam"
        ".cert"
        ".local/share/Steam"
        # TODO: I am not sure what this is, but it got pulled in with Steam I believe.
        ".local/share/vulkan"
        ".local/share/atuin"
        ".local/share/password-store"
        ".local/share/DBeaverData"
        ".local/share/direnv/allow"
        "documents"
        "downloads"
        "projects"
      ];

      files = [ ".ssh/known_hosts" ];
    };

    users.root = {
      home = "/root";
      directories = [ ".gnupg" ];
    };
  };

  # TODO: How would this work if I have a completely new install? I would still have to activate my home environment for the first time?
  environment.loginShellInit = ''
    # Activate home-manager environment, if not already
    [ -d "$HOME/.nix-profile" ] || /nix/var/nix/profiles/per-user/$USER/home-manager/activate &> /dev/null
  '';
}
