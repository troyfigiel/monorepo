{
#   services.syncthing = {
#     enable = true;
#     user = "troy";
#     configDir = "/home/troy/.config/syncthing";
#     overrideDevices = true;
#     overrideFolders = true;
#     devices = {
#       "Raspberry Pi".id =
#         "I2X3E7U-A6WNSZI-W222VHC-IN5ZSO5-BMZMSCQ-E5THLGB-2HNF2MA-HDBNEAH";
#     };
#     folders = {
#       # Can this be anything besides the folder ID?
#       "cjwuz-qsuvo" = {
#         path = "/home/troy/our-files";
#         devices = [ "Raspberry Pi" ];
#       };
#       "ansoq-roezf" = {
#         path = "/home/troy/misc-files";
#         devices = [ "Raspberry Pi" ];
#       };
#     };
#   };
}
