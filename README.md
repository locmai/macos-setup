# nix nix nix

![nix nix nix](./nix.jpeg)

Declarative macOS workstation setup using [nix-darwin](https://github.com/LnL7/nix-darwin) and [home-manager](https://github.com/nix-community/home-manager). Manages system packages, Homebrew formulae and casks, macOS defaults, and the user environment through Nix flakes.

## Quick start

```
make build
```

This installs Nix and Homebrew if missing, then runs `darwin-rebuild switch --flake .` against the host matching the current machine.

## Common commands

```
make build       # apply configuration (bootstraps Nix and Homebrew on first run)
make update      # nix flake update
make up          # run tools/update.ts to bump pinned versions
make optimize    # nix store optimise
make dotfiles    # initialize ~/dotfiles bare repo from github.com/locmai/dotfiles
```

To re-apply after the initial build:

```
darwin-rebuild switch --flake .
```

## Layout

```
flake.nix                    # hosts, inputs, helper functions
modules/
  darwin.nix                 # core system config, Homebrew, macOS defaults, zsh, direnv
  home/claude.nix            # home-manager config for Claude tooling
  packages/
    cloud.nix                # kubectl, helm, argocd, Azure CLI, k9s, kind
    fonts.nix                # font packages
    lsp.nix                  # language servers and dev tooling
    utilities.nix            # general CLI tools and MCP servers (uses pkgs-unstable)
tools/update.ts              # version bump helper
```

Inputs are pinned to the 25.11 release channels for `nixpkgs`, `nix-darwin`, and `home-manager`, with `nixpkgs-unstable` available for bleeding-edge packages in `utilities.nix`.

## Hosts

Defined in `flake.nix` via the `mkDarwinConfig` and `mkHostModule` helpers:

- `AM-H6MRWRT99L` and `AS-CCW7VHW44G`: work machines (`lmai`)
- `test`: CI configuration

To add a host:

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

## Adding packages

Always prefer Nix over Homebrew.

1. Search nixpkgs: `nix-env -qaP | grep <name>` or https://search.nixos.org
2. Add it to the matching module under `modules/packages/`:
   - `lsp.nix` for language servers and dev tooling
   - `cloud.nix` for Kubernetes and cloud infra tools
   - `utilities.nix` for general utilities and MCP servers (supports `pkgs-unstable.<package>`)
   - `fonts.nix` for fonts
   - `darwin.nix` only for core system packages
3. Fall back to a Homebrew brew or cask only when the package is missing or broken in nixpkgs, and document the reason. Current exceptions: `llvm`, `libpq`, `tfenv` (brews); `kitty`, `cursor`, `signal`, `session-manager-plugin` (casks).
4. Apply: `darwin-rebuild switch --flake .`

## Notes

- State version is 6. Run `darwin-rebuild changelog` before changing it.
- TouchID authentication is enabled for sudo.
- Unfree packages are allowed.
- `auto-optimise-store` is disabled. Run `make optimize` manually.
