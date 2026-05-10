{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    k3d
  ];
}
