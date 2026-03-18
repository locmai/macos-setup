{ pkgs, pkgs-unstable, ... }: {
  environment.systemPackages = with pkgs; [
    # Security
    openssl
    trivy
    zizmor

    # Containers
    k3d

    # Build tools
    protobuf
    go-task
    cmake

    # Cloud
    awscli2
    cmctl
    ingress2gateway

    # Utilities
    fastfetch
    dyff
    keycastr
    lua
    qmk

    # MCP servers
    pkgs-unstable.opencode
    pkgs-unstable.playwright-mcp
    mcp-grafana

    google-chrome
    unnaturalscrollwheels
    pinentry_mac
  ];
}
