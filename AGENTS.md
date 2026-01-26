# AGENTS.md

Guidelines for AI coding agents working in this nix-darwin macOS setup repository.

## Overview

Declarative macOS workstation configuration using:
- **nix-darwin**: macOS system configuration framework
- **home-manager**: User environment and dotfiles management
- **Nix flakes**: Reproducible dependency management (nixos-25.11 channel)

## Build Commands

### Primary Commands

```bash
# Initial setup (installs Nix + Homebrew if needed, applies configuration)
make build

# Apply configuration changes after editing .nix files
darwin-rebuild switch --flake .

# Update all flake dependencies
make update
# or
nix flake update

# Optimize Nix store (deduplicate)
make optimize
```

### Validation and Debugging

```bash
# Check flake syntax without building
nix flake check

# Show flake outputs
nix flake show

# Dry-run build (shows what would be built)
darwin-rebuild build --flake . --dry-run

# Search for available packages
nix-env -qaP | grep <package-name>

# Check changelog before state version changes
darwin-rebuild changelog
```

### No Tests

This repository has no test suite. Validation is done by successfully running `darwin-rebuild switch --flake .` which evaluates all Nix expressions and applies the configuration.

## Architecture

```
flake.nix                    # Entry point - defines inputs and darwinConfigurations
├── configuration.nix        # Core packages, Homebrew, macOS defaults, programs
├── lsp.nix                  # Language servers and dev tooling
├── cloud.nix                # Kubernetes and cloud tools
├── utilities.nix            # General utilities (uses pkgs-unstable)
├── fonts.nix                # Font packages
├── npm.nix                  # Node.js ecosystem + activation scripts
└── hosts/
    └── <hostname>.nix       # Host-specific config with home-manager
```

### Module Responsibilities

| Module | Purpose |
|--------|---------|
| `configuration.nix` | Core CLI tools, Homebrew integration, macOS system.defaults, nix settings |
| `lsp.nix` | Language servers: Rust, Python, Go, Node, Terraform, Nix, Lua, .NET |
| `cloud.nix` | kubectl, helm, argocd, azure-cli, k9s, kind, kustomize |
| `utilities.nix` | General utils, MCP servers, unstable packages |
| `fonts.nix` | Nerd fonts |
| `npm.nix` | Node.js runtime, npm packages, activation scripts |
| `hosts/*.nix` | Per-machine config, home-manager user setup |

## Code Style Guidelines

### Module Structure

```nix
# Standard module signature with destructured arguments
{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    package-name
  ];
}

# Module with multiple inputs
{ config, pkgs, ... }: { ... }

# Module using unstable packages
{ pkgs, pkgs-unstable, ... }: { ... }

# Module with let bindings
{ ... }:
let
  username = "lmai";
in {
  ...
}
```

### Formatting Rules

- **Indentation**: 2 spaces (never tabs)
- **Line length**: No hard limit, but keep readable
- **Semicolons**: Required after each attribute assignment
- **Opening braces**: Same line as function signature
- **Closing braces**: Own line, aligned with opening statement

### Package Lists

```nix
environment.systemPackages = with pkgs; [
  # Section comment for grouping
  package-a
  package-b

  # Another section
  package-c
  package-d

  # Complex packages with extensions
  (pass.withExtensions (ext: with ext; [ pass-otp ]))
];
```

- Use `with pkgs;` to avoid `pkgs.` prefix repetition
- One package per line
- Group related packages with blank lines and comments
- Use `# comment` for disabled packages: `# istioctl`

### Naming Conventions

| Item | Convention | Example |
|------|------------|---------|
| Module files | lowercase, descriptive | `cloud.nix`, `lsp.nix` |
| Host files | exact hostname | `AM-H6MRWRT99L.nix` |
| Let bindings | camelCase | `username`, `pkgsUnstable` |
| Nix options | kebab-case | `auto-optimise-store` |
| Environment vars | UPPER_SNAKE | `KUBE_EDITOR` |

### Attribute Sets

```nix
# Multi-line attribute sets
homebrew = {
  enable = true;
  taps = [ "owner/repo" ];
  brews = [ "package" ];
  casks = [ "app" ];
};

# Nested attributes
system.defaults = {
  dock = {
    autohide = true;
    mru-spaces = false;
  };
};
```

### Lists

```nix
# Short lists - single line
taps = [ "FelixKratz/formulae" "chainguard-dev/tap" ];

# Long lists - one item per line
brews = [
  "cookiecutter"
  "pinentry"
  "llvm"
];
```

## Package Management Strategy

Priority order for adding packages:

1. **Nix packages** (`environment.systemPackages`): Preferred for most tools
2. **Homebrew brews** (`homebrew.brews`): Tools with poor Nix support
3. **Homebrew casks** (`homebrew.casks`): GUI applications only

### Adding a Package

1. Determine the appropriate module:
   - Dev tools/LSPs → `lsp.nix`
   - Kubernetes/cloud → `cloud.nix`
   - General utilities → `utilities.nix` or `configuration.nix`
   - Fonts → `fonts.nix`
   - Node packages → `npm.nix`
   - Host-specific → `hosts/<hostname>.nix`

2. Search for the package: `nix-env -qaP | grep <name>`

3. Add to the correct module's `environment.systemPackages`

4. Apply: `darwin-rebuild switch --flake .`

### Using Unstable Packages

```nix
# In utilities.nix (has access to pkgs-unstable)
{ pkgs, pkgs-unstable, ... }: {
  environment.systemPackages = with pkgs; [
    stable-package
    pkgs-unstable.bleeding-edge-package
  ];
}
```

## Important Configuration Details

- **Architecture**: aarch64-darwin (Apple Silicon)
- **State version**: 6 (darwin), 22.11 (home-manager)
- **Primary user**: lmai
- **Experimental features**: `nix-command`, `flakes`
- **Unfree packages**: Allowed
- **TouchID sudo**: Enabled
- **Auto-optimize store**: Disabled (run `make optimize` manually)

## Common Patterns

### Homebrew Configuration

```nix
homebrew = {
  enable = true;
  taps = [ "owner/repo" ];
  brews = [ "formula" ];
  casks = [ "application" ];
};
```

### macOS System Defaults

```nix
system.defaults = {
  dock.autohide = true;
  NSGlobalDomain.AppleInterfaceStyle = "Dark";
  CustomUserPreferences."com.apple.Safari" = {
    IncludeDevelopMenu = true;
  };
};
```

### Home-Manager User Config

```nix
home-manager.users.${username} = { pkgs, ... }: {
  home.stateVersion = "22.11";
  programs.home-manager.enable = true;
  home.packages = with pkgs; [ user-specific-package ];
};
```

## Error Handling

- Nix expressions fail fast on syntax errors during evaluation
- `darwin-rebuild switch` will abort if any module fails to evaluate
- Always verify changes compile before committing: `darwin-rebuild build --flake .`
