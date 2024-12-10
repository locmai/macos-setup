{pkgs, ...}: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep curl

  environment.systemPackages = with pkgs; [
    # Rust
    rustfmt
    rust-analyzer
    # Python
    ruff
    uv
    # Go
    gopls
    gotools

    # NodeJS
    nodePackages.npm
    nodePackages.yarn
    nodejs

    # Terraform
    tflint
    # Nix
    nixfmt-classic
    alejandra
    # Lua
    stylua
    lua-language-server
  ];
}
