{ inputs, lib, self, ... }:

let
  mkSystem = { host, system, configuration, impermanence, secrets }: {
    name = host;
    value = inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs self impermanence; };
      pkgs = self.legacyPackages.${system};
      modules = [
        inputs.impermanence.nixosModules.impermanence
        { networking.hostName = host; }
        ./configuration/${configuration}
        (./hardware-configuration + "/${host}.nix")
        # TODO: Add secrets to all systems (at least a login password)
        inputs.sops-nix.nixosModules.sops
        (lib.mkIf secrets {
          sops.defaultSopsFile = ./configuration/${configuration}/secrets.yaml;
        })
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
in {
  flake = {
    nixosConfigurations = builtins.listToAttrs (map mkSystem [
      {
        host = "laptop";
        system = "x86_64-linux";
        configuration = "workstations/home";
        impermanence = true;
        secrets = true;
      }
      {
        host = "cloud-server";
        system = "x86_64-linux";
        configuration = "servers/cloud";
        impermanence = false;
        secrets = true;
      }
      {
        host = "virtual-devbox";
        system = "aarch64-linux";
        configuration = "workstations/virtual";
        impermanence = true;
        secrets = false;
      }
      {
        host = "raspberry";
        system = "aarch64-linux";
        configuration = "servers/home";
        impermanence = false;
        secrets = false;
      }
    ]);

    deploy.nodes = builtins.listToAttrs (map mkDeploy [
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
    ]);
  };

  perSystem = { pkgs, ... }: {
    apps = {
      bootstrap = {
        type = "app";
        program = pkgs.callPackage ./bootstrap.nix { };
      };

      infrastructure = {
        type = "app";
        program = pkgs.writeShellApplication {
          name = "monorepo-terraform";
          runtimeInputs = with pkgs; [ coreutils execline.bin terraform ];
          text = ''
            cd machines/terraform || exit 1
            terraform init
            terraform apply
            terraform output -json > outputs.json
          '';
        };
      };
    };
  };

  # TODO: The checks cause problems when the remote system does not have the same architecture as
  # the localhost, even when I set remoteBuild = true; I have opted to remove the checks for now,
  # but there should be a better solution. See: https://github.com/serokell/deploy-rs/issues/167.
  # perSystem = { system, ... }: { checks = inputs.deploy-rs.lib.${system}.deployChecks inputs.self.deploy; };
}
