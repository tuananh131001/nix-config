# nix-config

## Rebuild command

### VM macos fusion 13.6.4
`sudo NIXPKGS_ALLOW_UNFREE=1 NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM=1 nixos-rebuild switch --impure --flake "#vm-aarch64"`

### Intel PC
`sudo NIXPKGS_ALLOW_UNFREE=1 NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM=1 nixos-rebuild switch --impure --flake "#pc-intel"`

- Fix sound on line out is muted/not working
    1. Enter `alsamixer`
    2. F6 to select the correct sound card
    3. Move to right and use up/down key to change Auto Mute to disable


# Vietnamese Linux Typing
Use 'fcitx5-configtool' for config vietnamese typing system

