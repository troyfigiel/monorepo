{ lib }:

let
  inherit (builtins) filter readDir typeOf;
  inherit (lib)
    flatten hasSuffix mapAttrs mapAttrs' mapAttrsToList nameValuePair;
in rec {
  absoluteReadDir = dir:
    mapAttrs' (name: value: nameValuePair "${toString dir}/${name}" value)
    (readDir dir);

  absoluteReadDirRec = dir:
    mapAttrs (name: value:
      if value == "directory" then (absoluteReadDirRec name) else value)
    (absoluteReadDir dir);

  mapAttrsToListRec = f: attrs:
    mapAttrsToList (name: value:
      if typeOf value == "set" then mapAttrsToListRec f value else f name value)
    attrs;

  findNixFilesRec = dir:
    filter (file: hasSuffix ".nix" file)
    (flatten (mapAttrsToListRec (name: value: name) (absoluteReadDirRec dir)));

  # TODO: If there is a default.nix in a directory, I should only import the default.nix, not the rest.
  # TODO: Maybe in the future I might want to define nixosModules in my flake? That does not work like this, because I am returning a list
}
