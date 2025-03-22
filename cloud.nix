{pkgs, ...}: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep curl

  environment.systemPackages = with pkgs; [
    azure-cli
    azure-storage-azcopy
    kind
    thanos
    chart-testing
    kubernetes-helmPlugins.helm-unittest
  ];
}
