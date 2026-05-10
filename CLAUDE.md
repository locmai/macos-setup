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
    ├── build.nix          # Build tools (protobuf, cmake, go-task)
    ├── cloud.nix          # Kubernetes, cloud providers, IaC
    ├── containers.nix     # Local container runtimes (k3d)
    ├── desktop.nix        # Window manager, bar, GUI utilities, browsers
    ├── fonts.nix          # Font packages
    ├── lsp.nix            # Language servers and dev tooling
    ├── mcp.nix            # MCP servers (uses `pkgs-unstable`)
    ├── security.nix       # Security tooling (openssl, trivy, zizmor)
    └── utilities.nix      # General CLI utilities (starship, ffmpeg, etc.)
```

- **modules/darwin.nix**: Core system packages, Homebrew, macOS defaults, environment variables, programs (zsh, direnv)
- **modules/packages/lsp.nix**: Language servers and dev tooling (Rust, Python, Go, NodeJS, Terraform, Nix, Lua, .NET)
- **modules/packages/cloud.nix**: Kubernetes, cloud providers (AWS, Azure), cert/gateway tooling, IaC, service mesh
- **modules/packages/build.nix**: Build tools (protobuf, cmake, go-task)
- **modules/packages/containers.nix**: Local container runtimes (k3d)
- **modules/packages/security.nix**: Security tooling (openssl, trivy, zizmor)
- **modules/packages/mcp.nix**: MCP servers, uses `pkgs-unstable` for bleeding-edge packages
- **modules/packages/desktop.nix**: Window manager, bar, GUI utilities, browsers, pinentry
- **modules/packages/utilities.nix**: General CLI utilities (starship, fastfetch, dyff, ffmpeg, lua, qmk)
- **modules/packages/fonts.nix**: Font packages

### Package Management Layers

**IMPORTANT: Always prefer Nix packages over Homebrew unless there's a specific reason not to.**

1. **Nix packages** (`environment.systemPackages`): **DEFAULT CHOICE** for all tools and applications
   - Check nixpkgs first: `nix-env -qaP | grep <package-name>`
   - Use `pkgs-unstable.<package>` for bleeding-edge versions (in utilities.nix)
   - Even GUI applications should be installed via Nix when available

2. **Homebrew brews**: Only for tools with poor/broken Nix support
   - Current exceptions: llvm, libpq, tfenv
   - Require explicit justification before adding new brews

3. **Homebrew casks**: Only as last resort for GUI apps not in nixpkgs
   - Current exceptions: kitty, cursor, signal, session-manager-plugin
   - Always check nixpkgs availability first

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

**Follow this process strictly:**

1. **Search nixpkgs first**: Run `nix-env -qaP | grep <package-name>` or check https://search.nixos.org
2. **Add to appropriate Nix module** in `modules/packages/` based on category:
   - `lsp.nix`: Language servers and development tools
   - `cloud.nix`: Kubernetes, cloud providers, cert/gateway, IaC, service mesh
   - `build.nix`: Build tools (protobuf, cmake, go-task)
   - `containers.nix`: Local container runtimes (k3d)
   - `security.nix`: Security tooling (openssl, trivy, zizmor)
   - `mcp.nix`: MCP servers (supports `pkgs-unstable`)
   - `desktop.nix`: Window manager, bar, GUI utilities, browsers, pinentry
   - `utilities.nix`: General CLI utilities (shell prompt, media, scripting)
   - `fonts.nix`: Font packages
   - `darwin.nix`: Core system packages only
3. **Use `pkgs-unstable.<package>`** for bleeding-edge versions (available in `mcp.nix` and `cloud.nix`)
4. **Only use Homebrew if**:
   - Package doesn't exist in nixpkgs
   - Nix version is broken or unmaintained
   - Specific technical reason requires Homebrew (document why)
5. **Apply changes**: `darwin-rebuild switch --flake .`

**DO NOT default to Homebrew. Always try Nix first.**

## Important Notes

- State version is 6 (check `darwin-rebuild changelog` before changing)
- TouchID authentication enabled for sudo
- Unfree packages allowed
- Auto-optimise-store disabled (use `make optimize` manually)
