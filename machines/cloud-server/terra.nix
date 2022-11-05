let
  parameters = import ../parameters.nix;
  inherit (parameters.cloud-server) machine;
  inherit (parameters.cloud-server.website) domain pqdn;
in {
  my = {
    machines.vultr = {
      enable = true;
      inherit machine pqdn;
    };

    records = {
      mail = {
        enable = true;
        inherit domain pqdn;
      };

      searx = {
        enable = true;
        inherit domain pqdn;
      };

      webhosting = {
        enable = true;
        inherit domain pqdn;
      };
    };
  };
}
