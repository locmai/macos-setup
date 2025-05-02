{pkgs, ...}: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep curl

  environment.systemPackages = with pkgs; [
    # Rust
    cargo
    rustfmt
    rust-analyzer
    # Python
    ruff
    uv
    python312Packages.python-lsp-server
    python312Packages.pylsp-rope
    # Go
    go
    gopls
    gotools

    # NodeJS
    nodejs_23

    # Terraform
    tflint
    hclfmt
    # Nix
    nixfmt-classic
    alejandra
    # Lua
    stylua
    lua-language-server

    # .NET
    dotnet-sdk

    # Nix
    nixd

    # who knows
    markdown-oxide
    cmake-language-server
    jsonfmt
    terraform-ls
  ];
}
