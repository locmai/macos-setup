{ pkgs, pkgs-unstable, ... }: {
  environment.systemPackages = (with pkgs; [
    mcp-grafana
  ]) ++ [
    pkgs-unstable.opencode
    pkgs-unstable.playwright-mcp
  ];
}
