{ inputs, ... }:

{
  home-manager.users.troy = {
    imports = [ inputs.impermanence.nixosModules.home-manager.impermanence ];
  };
}
