{ config, lib, ... }:

let
  cfg = config.localModules.sops;
  inherit (lib) mkEnableOption mkIf mkOption types;
in {
  options.localModules.sops = {
    enable = mkEnableOption "sops-nix";

    defaultSopsFile = mkOption {
      type = types.path;
      description = ''
        Default sops file used for all secrets.
      '';
    };

    sshPath = mkOption {
      type = types.path;
      description = ''
        Path to the host ssh keys used by sops.
      '';
    };
  };

  config = mkIf cfg.enable {
    sops = {
      defaultSopsFile = cfg.defaultSopsFile;
      gnupg.sshKeyPaths = [ "${cfg.sshPath}/ssh_host_rsa_key" ];
      age.sshKeyPaths = [ ];
    };

    services.openssh = {
      enable = true;
      passwordAuthentication = false;
      permitRootLogin = "yes";

      hostKeys = [
        {
          bits = 4096;
          path = "${cfg.sshPath}/ssh_host_rsa_key";
          type = "rsa";
        }
        {
          path = "${cfg.sshPath}/ssh_host_ed25519_key";
          type = "ed25519";
        }
      ];
    };
  };
}
