{ pkgs, ... }: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep curl

  environment.systemPackages = with pkgs; [
    openssl
    zizmor
    keycastr
    trivy
    kitty
    go-task
    colima
    k3d
    protobuf
    qmk
    gurk-rs
    fastfetch
    # aerospace
    # sketchybar-app-font
    lua
    # jankyborders
    discord
    cmctl
    firefox
  ];
}
