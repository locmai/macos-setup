{...}: let
  username = "locmai";
in {
  users.users.${username}.home = "/Users/${username}";

  homebrew = {
    casks = [
      "firefox"
    ];
  };
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    users.${username} = {
      pkgs,
      lib,
      ...
    }: {
      home.stateVersion = "22.11";
      programs.home-manager.enable = true;
      home.packages = with pkgs; [
        (google-cloud-sdk.withExtraComponents [google-cloud-sdk.components.gke-gcloud-auth-plugin])
      ];
    };
  };
}
