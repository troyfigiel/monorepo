rec {
  flake = {
    machine = "virtual-devbox";
    system = "aarch64-linux";
    impermanence = true;
  };

  nixos = { hostName = flake.machine; };

  homeManager = {
    troy = {

    };
  };
}
