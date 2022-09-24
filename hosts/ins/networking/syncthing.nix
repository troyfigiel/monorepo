{
#   services.syncthing = {
#     enable = true;
#     user = "troy";
#     configDir = "/home/troy/.config/syncthing";
#     overrideDevices = true;
#     overrideFolders = true;
#     devices = {
#       "raspberrypi".id =
#         "NTIKLAK-WZDJKEO-K2LFHO2-2ZWC7PE-U2IPHIG-HSF2CKC-PKJY7QW-EILSJQT";
#     };
#     folders = {
#       "cjwuz-qsuvo" = {
#         path = "/nix/persist";
#         devices = [ "raspberrypi" ];
#         ignorePerms = false;
#       };
#     };
#   };
}
