# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Declarative macOS workstation setup using nix-darwin and home-manager. Manages system packages, Homebrew formulae/casks, macOS system defaults, and user environment configuration through Nix flakes.

## Architecture

### Flake Structure

The flake uses helper functions to reduce duplication:

- `mkDarwinConfig`: Creates a darwin system configuration with all modules
- `mkHostModule`: Generates host-specific configuration with home-manager setup

Inputs (all pinned to 25.11):
- `nixpkgs`: NixOS package collection
- `nixpkgs-unstable`: Unstable channel for bleeding-edge packages
- `darwin`: nix-darwin macOS framework
- `home-manager`: User environment management

### Module Organization

```
modules/
├── darwin.nix              # Core system config
└── packages/
    ├── cloud.nix          # Kubernetes and cloud tools
    ├── fonts.nix          # Font packages
    ├── lsp.nix            # Language servers and dev tooling
    └── utilities.nix      # General utilities and MCP servers
```

- **modules/darwin.nix**: Core system packages, Homebrew, macOS defaults, environment variables, programs (zsh, direnv)
- **modules/packages/lsp.nix**: Language servers and dev tooling (Rust, Python, Go, NodeJS, Terraform, Nix, Lua, .NET)
- **modules/packages/cloud.nix**: Kubernetes and cloud tools (kubectl, helm, argocd, Azure CLI, k9s, kind)
- **modules/packages/utilities.nix**: General utilities, MCP servers, uses `pkgs-unstable` for bleeding-edge packages
- **modules/packages/fonts.nix**: Font packages

### Package Management Layers

1. **Nix packages** (`environment.systemPackages`): Preferred for most tools
2. **Homebrew brews**: Tools with poor Nix support (llvm, libpq, tfenv, istioctl)
3. **Homebrew casks**: GUI applications (kitty, cursor, signal)

For unstable packages, use `pkgs-unstable.<package>` in modules that accept it.

## Commands

```bash
# Initial setup (installs Nix, Homebrew, applies configuration)
make build

# Apply configuration changes
darwin-rebuild switch --flake .

# Update flake.lock dependencies
make update

# Search for packages
nix-env -qaP | grep <package-name>

# Optimize Nix store
make optimize
```

## Adding a New Host

Add a new entry in `flake.nix`:

```nix
"NEW-HOSTNAME" = mkDarwinConfig {
  hostname = "NEW-HOSTNAME";
  hostModule = mkHostModule {
    username = "username";
    extraCasks = [ "app1" "app2" ];
    extraPackages = [ pkgs.some-package ];
  };
};
```

## Adding Packages

1. Choose the appropriate module in `modules/packages/` based on category
2. Prefer Nix packages over Homebrew
3. Use `pkgs-unstable` for bleeding-edge versions (only in `modules/packages/utilities.nix`)
4. Run `darwin-rebuild switch --flake .` to apply

## Important Notes

- State version is 6 (check `darwin-rebuild changelog` before changing)
- TouchID authentication enabled for sudo
- Unfree packages allowed
- Auto-optimise-store disabled (use `make optimize` manually)
