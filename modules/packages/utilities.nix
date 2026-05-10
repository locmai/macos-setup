{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # Shell / prompt
    starship
    fastfetch

    # Diff and data
    dyff

    # Media
    ffmpeg

    # Scripting and hardware
    lua
    qmk
  ];
}
