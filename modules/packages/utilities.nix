{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # Diff and data
    dyff

    # Media
    ffmpeg

    # Scripting and hardware
    lua
    qmk

    # AI hype train
    pi-coding-agent
  ];
}
