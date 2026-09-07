{ pkgs, pkgs-unstable, ... }: {
  environment.systemPackages = (with pkgs; [ k3d ]) ++ [
    # OCI registry client (unstable channel)
    pkgs-unstable.oras
  ];
}
