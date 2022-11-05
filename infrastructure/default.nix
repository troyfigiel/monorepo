{ inputs, self, ... }:

let
  inherit (inputs.terranix.lib) terranixConfiguration;
  inherit (self) terranixModules;
in {
  perSystem = { system, ... }: {
    packages.infrastructure = terranixConfiguration {
      inherit system;
      modules = [
        terranixModules.machines.vultr
        terranixModules.records.mail
        terranixModules.records.searx
        terranixModules.records.webhosting
        ./main.nix
        ../machines/cloud-server/terra.nix
      ];
    };
  };
}
