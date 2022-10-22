let parameters = import ./parameters.nix;
in {

  features = {
    machines.vultr = {
      enable = true;
      machine = parameters.flake.machine;
      pqdn = parameters.terranix.webserver.pqdn;
    };

    records = {
      mail = {
        enable = true;
        domain = parameters.terranix.webserver.domain;
        pqdn = parameters.terranix.webserver.pqdn;
      };

      searx = {
        enable = true;
        domain = parameters.terranix.webserver.domain;
        pqdn = parameters.terranix.webserver.pqdn;
      };

      webhosting = {
        enable = true;
        domain = parameters.terranix.webserver.domain;
        pqdn = parameters.terranix.webserver.pqdn;
      };
    };
  };
}

