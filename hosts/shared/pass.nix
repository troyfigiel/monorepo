{ config, ... }:

let
  inherit (config.home-manager.users.troy.home) homeDirectory;
  passwordStoreDirectory = ".local/share/password-store";
in {
  home-manager.users.troy = {
    programs.password-store = {
      enable = true;
      settings = {
        PASSWORD_STORE_DIR = "${homeDirectory}/${passwordStoreDirectory}";
      };
    };

    home.persistence."/nix/persist/${homeDirectory}" = {
      directories = [ passwordStoreDirectory ];
      allowOther = true;
    };
  };
}
