{...}: let
  username = "lmai";
in {
  users.users.${username}.home = "/Users/${username}";
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
        sops
      ];
    };
  };
}
