# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Declarative macOS workstation setup using nix-darwin and home-manager. This repository manages system packages, Homebrew formulae/casks, macOS system defaults, and user environment configuration through Nix flakes.

## Architecture

### Flake-based Configuration

The repository uses Nix flakes (nixos-25.11 channel) with inputs:
- `nixpkgs`: NixOS package collection
- `nix-darwin`: macOS system configuration framework
- `home-manager`: User environment and dotfiles management

Configuration is split into modular `.nix` files imported by `flake.nix`:

- **configuration.nix**: Core system packages, Homebrew integration, macOS system defaults (dock, keyboard, Safari), environment variables, and zsh/direnv programs
- **lsp.nix**: Language server protocols and development tooling (Rust, Python, Go, NodeJS, Terraform, Nix, Lua, .NET)
- **cloud.nix**: Cloud-native and Kubernetes tools (kubectl, helm, argocd, Azure CLI, k9s, kind)
- **utilities.nix**: General utilities (openssl, trivy, colima, k3d, protobuf, awscli2)
- **fonts.nix**: Font packages (Nerd Fonts Ubuntu Mono)
- **hosts/*.nix**: Host-specific configurations with home-manager user setup

### System Configuration

The flake defines `darwinConfigurations` for specific machine hostnames (e.g., "AM-H6MRWRT99L"). Each configuration:
1. Specifies system architecture (aarch64-darwin)
2. Imports all module files
3. Integrates home-manager for user-level configuration

Primary user is `lmai` with home directory `/Users/lmai`.

### Package Management Strategy

Packages are managed through three layers:
1. **Nix packages** (`environment.systemPackages`): Core tools, CLI utilities, language toolchains
2. **Homebrew brews**: Tools not well-supported in Nix (cookiecutter, pinentry, llvm, libpq, tfenv, istioctl)
3. **Homebrew casks**: GUI applications (kitty, cursor, signal)

Homebrew taps: FelixKratz/formulae, chainguard-dev/tap

## Common Commands

### Initial Setup
```bash
make build    # Install Nix, Homebrew, and apply darwin-rebuild switch
```

This command:
1. Installs Nix if `/nix` doesn't exist
2. Installs Homebrew if `/opt/homebrew/bin/brew` doesn't exist
3. Runs `darwin-rebuild switch --flake .` with experimental features enabled

### Apply Configuration Changes
```bash
# After modifying any .nix files:
darwin-rebuild switch --flake .
```

### Update Dependencies
```bash
make update              # Update flake.lock (nix flake update)
nix flake update         # Same as above
```

### Sync Dotfiles
```bash
make dotfiles    # Initialize dotfiles repo from github.com/locmai/dotfiles
```

### Optimize Nix Store
```bash
make optimize    # Run nix store optimise
```

### Development Workflow
```bash
# Search for available packages
nix-env -qaP | grep <package-name>

# Check darwin-rebuild changelog before state version changes
darwin-rebuild changelog
```

## Modifying the Configuration

When adding packages:
1. **Add to appropriate module**: Place packages in the semantically correct file (lsp.nix for dev tools, cloud.nix for k8s/cloud, etc.)
2. **Use Nix first**: Prefer `environment.systemPackages` over Homebrew
3. **Homebrew for exceptions**: Use `homebrew.brews` for tools with poor Nix support, `homebrew.casks` for GUI apps
4. **Apply changes**: Run `darwin-rebuild switch --flake .` after editing

When modifying system defaults:
- Edit `system.defaults` in configuration.nix
- Changes affect NSGlobalDomain, dock, Safari, and other macOS preferences

## Important Notes

- System uses `nix-command` and `flakes` experimental features
- State version is 6 (see configuration.nix:120)
- Homebrew prefix is added to system path via configuration
- TouchID authentication enabled for sudo via PAM
- Auto-optimise-store is disabled (use `make optimize` manually)
- Unfree packages are allowed (`nixpkgs.config.allowUnfree = true`)
- Zsh is managed by nix-darwin but completion/prompt handled externally (see user's dotfiles)
