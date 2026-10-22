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
            "AquaStar"
            "AquaStar2"
          ];
      };
    in
    {
      packages.${system} = {
        aquastar2 = pkgs.callPackage ./pkgs/aquastar2 { };
        aquastar = pkgs.callPackage ./pkgs/aquastar { };
      };
    };
}
