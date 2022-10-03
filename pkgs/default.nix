final: prev:

{
  sddm-sugar-candy = prev.callPackage ./sddm-sugar-candy.nix { };
  website = prev.callPackage ./website { };
}
