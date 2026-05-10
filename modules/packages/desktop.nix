{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # Window manager and bar
    aerospace
    sketchybar

    # Input and display utilities
    keycastr
    unnaturalscrollwheels

    # Browsers and web tooling
    google-chrome

    # GPG pinentry
    pinentry_mac
  ];
}
