{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    gnupg
    pinentry
    pass
  ];

  programs = {
    ssh.startAgent = false;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryFlavor = "gtk2";
    };
  };
}
