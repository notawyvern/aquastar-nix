# AquaStar Launcher for Nix

- [Support](#support)
    - [v3](#v3)
    - [v2](#v2)
- [Testing](#testing)
- [Install](#install)

## Support

### v3

Only Linux x86_64 is supported.

### v2

macOS is currently not available, only Linux. Architectures, verified by hashes, follow.

- x86_64
- i686
- armv7l

## Testing

This one-liner of Nix can run aquastar v3 before install:

```sh
NIXPKGS_ALLOW_UNFREE=1 nix run --impure github:notawyvern/aquastar-nix#aquastar
```

## Install

First [allow unfree packages](https://wiki.nixos.org/wiki/Unfree_software) and inherit inputs, then use flakes or adapt it accordingly:

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

```nix
enviroment.systemPackages = [
    inputs.aquastar-nix.packages.${pkgs.stdenv.hostPlatform.system}.aquastar2
];
```
