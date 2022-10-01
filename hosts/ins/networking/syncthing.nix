{
  # TODO: Why does Syncthing still create a Sync folder upon boot? How do I fix this?
  services.syncthing = {
    enable = true;
    user = "troy";
    configDir = "/home/troy/.config/syncthing";
    overrideDevices = true;
    overrideFolders = true;
    devices = {
      "raspberrypi".id =
        "NTIKLAK-WZDJKEO-K2LFHO2-2ZWC7PE-U2IPHIG-HSF2CKC-PKJY7QW-EILSJQT";
    };
    folders = {
      "cjwuz-qsuvo" = {
        path = "/nix/persist/home/troy";
        devices = [ "raspberrypi" ];
        ignorePerms = false;
      };
    };
  };
}
