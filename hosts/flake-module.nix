{ inputs, lib, self, ... }:

let
  mkSystem = { host, system, impermanence, secrets }: {
    name = host;
    value = inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs self impermanence; };
      pkgs = self.legacyPackages.${system};
      modules = [
        inputs.impermanence.nixosModules.impermanence
        { networking.hostName = host; }
        ./${host}
      ] ++ lib.optionals secrets [
        # TODO: Add secrets to all systems (at least a login password)
        inputs.sops-nix.nixosModules.sops
        { sops.defaultSopsFile = ./${host}/secrets.yaml; }
      ];
    };
  };
  mkDeploy = { host, hostname, remoteBuild }:
    let
      nixosConfig = self.nixosConfigurations.${host};
      inherit (nixosConfig.pkgs) system;
    in {
      name = host;
      value = {
        inherit hostname remoteBuild;
        sshUser = "root";
        autoRollback = true;
        magicRollback = true;
        profiles.system.path =
          inputs.deploy-rs.lib.${system}.activate.nixos nixosConfig;
      };
    };
  systemAttrs = [
    {
      host = "laptop";
      system = "x86_64-linux";
      impermanence = true;
      secrets = true;
    }
    {
      host = "cloud-server";
      system = "x86_64-linux";
      impermanence = false;
      secrets = true;
    }
    {
      host = "virtual-devbox";
      system = "aarch64-linux";
      impermanence = true;
      secrets = false;
    }
    {
      host = "raspberry";
      system = "aarch64-linux";
      impermanence = false;
      secrets = false;
    }
  ];
  deployAttrs = [
    {
      host = "cloud-server";
      # TODO: Do not hardcode this, but read it from Terraform!
      hostname = "95.179.241.168";
      remoteBuild = false;
    }
    {
      host = "raspberry";
      hostname = "192.168.178.31";
      remoteBuild = true;
    }
  ];
in {
  flake = {
    nixosConfigurations = builtins.listToAttrs (map mkSystem systemAttrs);
    deploy.nodes = builtins.listToAttrs (map mkDeploy deployAttrs);
  };

  # TODO: The checks cause problems when the remote system does not have the same architecture as
  # the localhost, even when I set remoteBuild = true; I have opted to remove the checks for now,
  # but there should be a better solution. See: https://github.com/serokell/deploy-rs/issues/167.
  # perSystem = { system, ... }: { checks = inputs.deploy-rs.lib.${system}.deployChecks inputs.self.deploy; };
}
