{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    nerd-fonts.ubuntu-mono
  ];
}
