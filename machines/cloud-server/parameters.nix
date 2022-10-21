rec {
  flake = {
    machine = "cloud-server";
    system = "x86_64-linux";
    impermanence = false;
  };

  nixos = {
    hostName = flake.machine;
    users = [ "nixos" ];
    webserver = {
      domain = "troyfigiel";
      pqdn = "${nixos.webserver.domain}.com";
    };
  };

  terranix = {
    inherit (flake) machine;
    webserver = { inherit (nixos.webserver) domain pqdn; };
  };
}
