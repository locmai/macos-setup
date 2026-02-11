{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # Rust
    cargo
    rustfmt
    rust-analyzer
    rustup

    # Python
    ruff
    uv
    python312Packages.python-lsp-ruff
    python312Packages.locust

    # Go
    go
    gopls
    gotools

    # NodeJS
    nodejs

    # Terraform
    tflint
    hclfmt
    terraform-ls

    # Nix
    nixfmt-classic
    alejandra
    nixd

    # Lua
    stylua
    lua-language-server

    # .NET
    dotnet-sdk

    # Other
    markdown-oxide
    cmake-language-server
    jsonfmt
  ];
}
