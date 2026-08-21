{ pkgs, ... }: {
  fonts.packages = with pkgs; [
    nerd-fonts.ubuntu-mono
    nerd-fonts.jetbrains-mono
    sketchybar-app-font
  ];
}
