{ inputs, self, ... }:

let
  mkSystem = { host, system, impermanence, ... }: {
    name = host;
    value = inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs self impermanence;
        inherit (self) hmModules nixosModules;
      };
      pkgs = self.legacyPackages.${system};
      modules = [ { networking.hostName = host; } ./${host} ];
    };
  };
  mkDeploy = { host, ipAddress }:
    let
      nixosConfig = self.nixosConfigurations.${host};
      inherit (nixosConfig.pkgs) system;
    in {
      name = host;
      value = {
        sshUser = "root";
        autoRollback = true;
        magicRollback = true;
        hostname = ipAddress;
        profiles.system.path =
          inputs.deploy-rs.lib.${system}.activate.nixos nixosConfig;
      };
    };
  systemAttrs = [
    {
      host = "laptop";
      system = "x86_64-linux";
      impermanence = true;
    }
    {
      host = "cloud-server";
      system = "x86_64-linux";
      impermanence = false;
    }
    {
      host = "virtual-devbox";
      system = "aarch64-linux";
      impermanence = true;
    }
  ];
  deployAttrs = [{
    host = "cloud-server";
    ipAddress = "troyfigiel.com";
  }];
in {
  flake = {
    nixosConfigurations = builtins.listToAttrs (map mkSystem systemAttrs);
    deploy.nodes = builtins.listToAttrs (map mkDeploy deployAttrs);
  };

  perSystem = { pkgs, system, ... }: {
    apps = {
      local = {
        type = "app";
        program = pkgs.writeShellApplication {
          name = "monorepo-local";
          runtimeInputs = [ pkgs.nixos-rebuild ];
          text = ''
            (( $# == 0 )) && command="switch" || command="$1"
            nixos-rebuild "$command" --flake .
          '';
        };
      };

      remote = {
        type = "app";
        program = pkgs.writeShellApplication {
          name = "monorepo-remote";
          runtimeInputs = [ pkgs.deploy-rs ];
          text = "deploy . -s";
        };
      };
    };

    checks = inputs.deploy-rs.lib.${system}.deployChecks inputs.self.deploy;
  };
}
