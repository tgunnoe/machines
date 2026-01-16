# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal NixOS/nix-darwin configuration repository using a flake-based structure. It manages system configurations for multiple machines including Linux systems (arrakis, chapterhouse, sietch-tabr) and macOS systems (geidi-prime) with home-manager integration.

## Development Commands

```bash
# Build NixOS system configuration
nix build .#nixosConfigurations.<hostname>.config.system.build.toplevel

# Build macOS (nix-darwin) configuration
nix build .#darwinConfigurations.geidi-prime.system

# Switch to new configuration (on target system)
sudo nixos-rebuild switch --flake .#<hostname>
darwin-rebuild switch --flake .#<hostname>

# Test configuration without switching
sudo nixos-rebuild test --flake .#<hostname>
darwin-rebuild check --flake .#<hostname>

# Enter development shell (provides ragenix and age tools)
nix develop

# Format all Nix files
nix fmt
```

## Architecture

### Module Hierarchy

The flake uses `flake-parts` and `nixos-flake` to organize modules into three tiers:

1. **commonModules** (`modules/common/`) - Shared between NixOS and Darwin
   - Nix settings, binary caches, terminal packages

2. **nixosModules** (`modules/nixos/`) - Linux-specific
   - Imports `commonModules.common`
   - GUI (Wayland/Sway/Hyprland), audio, virtualization, games, etc.

3. **darwinModules** (`modules/darwin/`) - macOS-specific
   - Imports `commonModules.common`
   - Darwin-specific settings and home-manager integration

### Home Manager Modules

Home modules in `home/` follow the same pattern:

- `homeModules.common` - Shared (terminal, git, direnv, kitty, zsh, doom-emacs)
- `homeModules.default` - Linux (imports common + GUI/Wayland packages)
- `homeModules.darwin` - macOS (imports common only)

### Key Directories

- `flake.nix` - System definitions, imports all modules from `modules/`, `users/`, `home/`, `shells/`
- `modules/` - Platform-specific modules (common, nixos, darwin)
- `systems/` - Host-specific hardware and configuration (arrakis.nix, chapterhouse.nix, sietch-tabr.nix)
- `home/` - Home Manager modules and user environment (gui/, doom.d/)
- `users/` - User definitions with `people.myself` option for the primary user
- `nixos/` - Legacy NixOS modules (being migrated to `modules/nixos/`)

### System Configurations

- **arrakis**: Framework 11th gen Intel laptop (x86_64-linux)
- **chapterhouse**: x86_64-linux system
- **sietch-tabr**: aarch64-linux system
- **geidi-prime**: aarch64-darwin (macOS Apple Silicon)