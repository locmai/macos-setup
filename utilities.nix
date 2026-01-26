{ pkgs, ... }: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep curl

  environment.systemPackages = with pkgs; [
    openssl
    opencode
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

    # MCP servers
    playwright-mcp
    mcp-k8s-go
  ];
}
