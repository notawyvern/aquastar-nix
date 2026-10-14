# AquaStar Launcher for Nix

- [Testing](#testing)
- [Install](#install)

## Testing

Through Nix, this one-liner can run the package before install:

```sh
NIXPKGS_ALLOW_UNFREE=1 nix run --impure github:notawyvern/aquastar-nix
```

## Install

Only x86_64 arch is currently supported. After [allowing unfree packages](https://wiki.nixos.org/wiki/Unfree_software) and inheriting inputs, use flakes or adapt it accordingly:

```nix
inputs = {
    aquastar-nix.url = "github:notawyvern/aquastar-nix";
    aquastar-nix.inputs.nixpkgs.follows = "nixpkgs";
};
```

```nix
enviroment.systemPackages = [
    inputs.aquastar-nix.packages.${pkgs.stdenv.hostPlatform.system}.aquastar
];
```
