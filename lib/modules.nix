# Import all modules
# Probably using some kind of flattening?
# It is a basic functional programming problem:
# Use readDir and if an attribute is a directory, apply readDir again.
# Recursive problem.

# builtins.mapAttrs (name: value: if value == "directory" then builtins.readDir ./modules/${name} else value) (builtins.readDir ./modules)

# {
#   mapModules = dir:
#     mapAttrs (name: value:
#       let path = "${toString dir}/${name}";
#       in if value == "directory" && pathExists "${path}/default.nix" then
#         nameValuePair name path
#       else if value == "regular" && hasSuffix ".nix" name then
#         nameValuePair (removeSuffix ".nix" name) path
#       else
#         nameValuePair "" null) (readDir dir);
# }

# Function f: { a = "directory"; b = "regular"; } -> { a = {...}; b = "regular"; }
# So f = mapAttrs (name: value: if value == "directory" then (readDir name) else value)

{ lib }:

let
  inherit (lib) nameValuePair mapAttrs mapAttrs' removeSuffix;
  inherit (builtins) readDir;
in rec {
  _prependDir = dir: name: value:
    nameValuePair ("${toString dir}/${name}") value;

  readDir' = dir: (mapAttrs' (_prependDir dir)) (readDir dir);

  singleRecurseDir = dir:
    mapAttrs
    (name: value: if value == "directory" then (readDir name) else value)
    (readDir' dir);

  # Once we have the full attribute list, we can apply attrsets.filterAttrsRecursive
  # Then we somehow flatten?
  # Finally we can apply attrsets.mapAttrsToList (name: value: name)

  ###############################

  # TODO: This works in my current case, but it will fail if the wrong files are in this directory.
  mapModules = fn: dir:
    mapAttrs' (name: value:
      nameValuePair (removeSuffix ".nix" name) (fn "${toString dir}/${name}"))
    (readDir dir);
}
