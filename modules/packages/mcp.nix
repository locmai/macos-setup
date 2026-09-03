{ pkgs, pkgs-unstable, ... }: {
  environment.systemPackages = (with pkgs; [ mcp-grafana ])
    ++ [ pkgs-unstable.playwright-mcp ];
}
