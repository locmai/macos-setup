{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # Kubernetes
    kubectl
    kubectx
    kubectl-view-allocations
    kubectl-tree
    k9s
    kind
    kubernetes-helm
    kubernetes-helmPlugins.helm-unittest
    helm-ls
    kustomize
    skaffold

    # GitOps
    argocd

    # Cloud providers
    azure-cli
    azure-storage-azcopy
    kubelogin

    # Observability
    thanos

    # IaC
    terraform-docs
    chart-testing
  ];
}
