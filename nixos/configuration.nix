# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot/efi";
  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";

  hardware.opengl.enable = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

  services.xserver = {
    enable = true;
    layout = "de";
    xkbVariant = "";

    videoDrivers = [ "modesetting" ];

    displayManager = {
      lightdm.enable = true;
      autoLogin.enable = true;
      autoLogin.user = "troy";
    };
    desktopManager.cinnamon.enable = true;

    libinput = {
      enable = true;
      touchpad.tapping = true;
    };
  };

  # Configure console keymap
  console.keyMap = "de";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable Bluetooth support
  hardware.bluetooth.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.troy = {
    isNormalUser = true;
    home = "/home/troy";
    description = "Troy Figiel";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
  };

  nixpkgs.config = {
    allowUnfree = true;
  }; 
  

  environment.systemPackages = with pkgs; [
    # Debugging
    w3m
    sqlite

    # Python
    python3

    # Text editor
    vim

    # Environment
    syncthing
    direnv
    chezmoi

    # Essentials
    git
    wget
    xclip

    # Security
    gnupg
    pinentry
    pass
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs = {
    ssh.startAgent = false;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryFlavor = "gtk2";
    };
  };

  # Allows communication with smartcards.
  services.pcscd.enable = true;  

  services.gnome.gnome-keyring.enable = pkgs.lib.mkForce false;

  #OpenVPN
  services.openvpn.servers = {
    workVPN.config = '' config /root/nixos/openvpn/workVPN.conf '';
  };

  # Flatpak
  services.flatpak.enable = true;

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  # Syncthing
  services.syncthing = {
    enable = true;
    user = "troy";
    dataDir = "/home/troy/Sync";
    configDir = "/home/troy/.config/syncthing";
    overrideDevices = true;
    overrideFolders = true;

    devices = {
      "Raspberry Pi".id = "I2X3E7U-A6WNSZI-W222VHC-IN5ZSO5-BMZMSCQ-E5THLGB-2HNF2MA-HDBNEAH";
    };
    
    folders = {
      # Can this be anything besides the folder ID?
      "cjwuz-qsuvo" = {
        path = "/home/troy/our-files";
        devices = [ "Raspberry Pi" ];
      };
      "ansoq-roezf" = {
        path = "/home/troy/misc-files";
        devices = [ "Raspberry Pi" ];
      };
    };
  };
  
  virtualisation.docker.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leavecatenate(variables, "bootdev", bootdev)
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}
