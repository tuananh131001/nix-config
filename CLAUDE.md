# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a NixOS configuration repository using flakes for managing system configurations across multiple machines. It uses home-manager for user-level package and configuration management.

## Architecture

### Core System Builder (`lib/mksystem.nix`)

The repository uses a custom system builder function that:
- Takes a machine name and configuration parameters (system architecture, user, optional darwin/wsl flags)
- Assembles three configuration layers:
  1. Machine-specific config from `machines/${name}.nix`
  2. User OS config from `users/${user}/nixos.nix` (or darwin.nix)
  3. User home-manager config from `users/${user}/home-manager.nix`
- Applies overlays (zig-overlay and keyd overlay)
- Injects context variables (`currentSystemName`, `currentSystemUser`, `isWSL`, etc.) that configs can use

### Configuration Hierarchy

```
flake.nix (defines systems)
  ├── lib/mksystem.nix (system builder)
  ├── machines/
  │   ├── {machine-name}.nix (machine-specific: hardware, boot, networking)
  │   ├── vm-shared.nix (shared VM settings)
  │   └── hardware/ (hardware-specific configs)
  └── users/{username}/
      ├── nixos.nix (OS-level user packages/services)
      └── home-manager.nix (user environment: shell, packages, dotfiles)
```

### Specializations

The system uses NixOS specializations for different desktop environments:
- `modules/specialization/plasma.nix` - KDE Plasma setup
- `modules/specialization/i3.nix` - i3 window manager setup

These allow switching between DEs at boot time.

## System Rebuild Commands

### VM (aarch64, VMware Fusion)
```bash
sudo NIXPKGS_ALLOW_UNFREE=1 NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM=1 nixos-rebuild switch --impure --flake "#vm-aarch64"
```

### Intel PC (x86_64)
```bash
sudo NIXPKGS_ALLOW_UNFREE=1 NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM=1 nixos-rebuild switch --impure --flake "#pc-intel"
```

**Note:** The `--impure` flag is required because the configs use `builtins.readFile` for external files (e.g., keyd config, i3 config).

## Configuration Details

### Keyboard Remapping
The system uses `keyd` for keyboard remapping with config in `machines/keyd`. Key mappings:
- Capslock → Meta/Super layer key
- Cmd layer: macOS-like shortcuts (Cmd+C, Cmd+V, etc.)
- Custom keyd overlay in `overlays/keyd.nix` with keyd-application-mapper for per-app configs

### Conditional Packages
User packages use `currentSystemName` to conditionally install machine-specific packages (e.g., discord-ptb and alsa-utils only on pc-intel).

### Desktop Environment
- Default: KDE Plasma 6 with SDDM (Wayland)
- Specializations available for KDE Plasma and i3
- i3 config is managed through home-manager's `xdg.configFile`

## Flake Inputs

- **nixpkgs**: nixos-25.11 stable channel
- **home-manager**: For user environment management (release-25.11)
- **zig**: Mitchell Hashimoto's zig overlay for latest zig versions
- **zen-browser**: Zen browser flake
- **plasma-manager**: KDE Plasma configuration management

## Key System Services

- **keyd**: System-wide keyboard remapping (capslock → meta/super layer with macOS-style shortcuts)
- **keyd-application-mapper**: Per-application keyboard configs (systemd user service)
- **gnome-keyring**: Secret management (enabled in home-manager)
- **NetworkManager**: Network management
- **fcitx5**: Input method for Vietnamese typing (configure with `fcitx5-configtool`)

## Development Tools Stack

Managed via home-manager, includes:
- **Shell**: fish with starship prompt, zoxide, mise
- **Editor**: neovim
- **Version control**: git, gh (GitHub CLI)
- **Languages**: nodejs (lts), python3, zig, ruby via mise
- **CLI utilities**: fzf, ripgrep, fd, htop, sesh, nixfmt
- **Terminal**: ghostty
- **Browser**: zen-browser (beta)

## Additional Commands

### Update Flake Packages
```bash
sudo nix flake update
```
