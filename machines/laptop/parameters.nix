rec {
  flake = {
    machine = "laptop";
    system = "x86_64-linux";
    impermanence = true;
  };

  nixos = { hostName = flake.machine; };
}
