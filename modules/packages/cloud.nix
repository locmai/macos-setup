{ pkgs, pkgs-unstable, ... }: {
  environment.systemPackages = (with pkgs; [
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
    awscli2
    azure-cli
    azure-storage-azcopy
    kubelogin

    # Cert management
    cmctl

    # Gateway / networking
    ingress2gateway

    # Observability
    thanos

    # IaC
    terraform-docs
    chart-testing
  ]) ++ [
    # Service mesh (unstable channel)
    pkgs-unstable.istioctl
  ];
}
