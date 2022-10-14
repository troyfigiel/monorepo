{ lib }:

let
  inherit (builtins) filter pathExists readDir typeOf;
  inherit (lib)
    flatten hasSuffix mapAttrs mapAttrs' mapAttrsToList nameValuePair;
in rec {
  absoluteReadDir = dir:
    mapAttrs' (name: value: nameValuePair "${toString dir}/${name}" value)
    (readDir dir);

  mapAttrsToListRec = f: attrs:
    mapAttrsToList (name: value:
      if typeOf value == "set" then mapAttrsToListRec f value else f name value)
    attrs;

  isModule = name: value:
    (value == "regular" && hasSuffix ".nix" name)
    || (value == "directory" && pathExists "${name}/default.nix");

  findModulesRec = dir:
    mapAttrs
    (name: value: if isModule name value then "module" else findModulesRec name)
    (absoluteReadDir dir);

  modulesToList = dir:
    flatten (mapAttrsToListRec (name: value: name) (findModulesRec dir));

  # TODO: Maybe in the future I might want to define nixosModules in my flake? That does not work like this, because I am returning a list
}
