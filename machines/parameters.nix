rec {
  cloud-server = {
    machine = "cloud-server";
    system = "x86_64-linux";
    impermanence = false;
    website = {
      domain = "troyfigiel";
      pqdn = "${cloud-server.website.domain}.com";
    };
  };

  laptop = {
    machine = "laptop";
    system = "x86_64-linux";
    impermanence = true;
  };

  virtual-devbox = {
    machine = "virtual-devbox";
    system = "aarch64-linux";
    impermanence = true;
  };
}
