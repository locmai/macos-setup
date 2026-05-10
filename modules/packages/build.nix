{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    protobuf
    go-task
    cmake
  ];
}
