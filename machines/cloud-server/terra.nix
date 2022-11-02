let parameters = import ./parameters.nix;
in {
  my = {
    machines.vultr = {
      enable = true;
      inherit (parameters.flake) machine;
      inherit (parameters.terranix.webserver) pqdn;
    };

    records = {
      mail = {
        enable = true;
        inherit (parameters.terranix.webserver) domain;
        inherit (parameters.terranix.webserver) pqdn;
      };

      searx = {
        enable = true;
        inherit (parameters.terranix.webserver) domain;
        inherit (parameters.terranix.webserver) pqdn;
      };

      webhosting = {
        enable = true;
        inherit (parameters.terranix.webserver) domain;
        inherit (parameters.terranix.webserver) pqdn;
      };
    };
  };
}
