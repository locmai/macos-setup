{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    openssl
    trivy
    zizmor
  ];
}
