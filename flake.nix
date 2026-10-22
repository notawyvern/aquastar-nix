{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfreePredicate =
          pkg:
          builtins.elem (pkgs.lib.getName pkg) [
            "aquastar-neo"
            "aquastar-classic"
          ];
      };
    in
    {
      packages.${system} = {
        aquastar-neo = pkgs.callPackage ./pkgs/aquastar-neo { };
        aquastar-classic = pkgs.callPackage ./pkgs/aquastar-classic { };
      };
    };
}
