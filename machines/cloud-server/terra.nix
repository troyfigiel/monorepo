let
  # TODO: I should not be referring to cloud-server here.
  machine = "cloud-server";
  parameters = import ./parameters.nix;
  inherit (parameters.website) domain pqdn;
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
