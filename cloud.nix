{pkgs, ...}: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep curl

  environment.systemPackages = with pkgs; [
    argocd
    azure-cli
    azure-storage-azcopy
    chart-testing
    kind
    k9s
    kubectl
    kubernetes-helmPlugins.helm-unittest
    kubectl-view-allocations
    kubectl-tree
    kubectx
    kubelogin
    kubernetes-helm
    kustomize
    skaffold
    thanos
    terraform-docs
  ];
}
