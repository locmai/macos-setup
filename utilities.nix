{ pkgs, pkgs-unstable, ... }: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep curl

  environment.systemPackages = with pkgs; [
    openssl
    pkgs-unstable.opencode
    zizmor
    keycastr
    trivy
    go-task
    colima
    k3d
    protobuf
    qmk
    fastfetch
    # aerospace
    # sketchybar-app-font
    lua
    # jankyborders
    cmctl
    awscli2
    dyff
    kubernetes-helmPlugins.helm-unittest

    rustup
    ingress2gateway
    ghostty-bin

    # MCP servers
    pkgs-unstable.playwright-mcp
    mcp-k8s-go
  ];
}
