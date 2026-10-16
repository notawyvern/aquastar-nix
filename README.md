# AquaStar Launcher for Nix

- [Support](#support)
- [Testing](#testing)
- [Install](#install)

## Support

macOS is currently not available, only Linux. Architectures follow.

**A Tier**: Tested on my hardware.

- x86_64

**B Tier**: Verified hashes.

- i686
- armv7l

## Testing

This one-liner of Nix can run the package before install:

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
