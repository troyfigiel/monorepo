{ config, inputs, ... }:

{
  home-manager.users.troy = {
    imports = [ inputs.impermanence.nixosModules.home-manager.impermanence ];

    home.persistence."/nix/persist/${config.home-manager.users.troy.home.homeDirectory}" =
      {
        directories = [ ".ssh" ];
        allowOther = true;
      };
  };
}
