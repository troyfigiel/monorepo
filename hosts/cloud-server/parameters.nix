let
  terraformOutputs =
    builtins.fromJSON (builtins.readFile ../../infrastructure/outputs.json);
in {
  system = "x86_64-linux";
  impermanence = false;

  deploy.ip = terraformOutputs.cloud-server_ip-address.value;

  website = rec {
    domain = terraformOutputs.website_domain.value;
    pqdn = terraformOutputs.website_pqdn.value;
  };
}