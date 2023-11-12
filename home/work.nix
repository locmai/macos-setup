{ pkgs, ... }:
let
  username = "lmai";
in
{
  # TODO https://github.com/LnL7/nix-darwin/issues/682

  users.users.${username}.home = "/Users/${username}";
  system.activationScripts.extraUserActivation.text = ''
    sudo pmset -a lowpowermode 1
  '';

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    users.${username} = { pkgs, lib, ... }: {
      home.stateVersion = "22.11";
      programs.home-manager.enable = true;
      home.packages = with pkgs; [
        argocd
        azure-cli
        cmctl
        istioctl
        kubelogin
        sops
        terragrunt
        tflint
        yq-go
      ];
    };
  };
}

