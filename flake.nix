{
  description = "Loc's macOS setup";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, darwin, home-manager }:
    let
      system = "aarch64-darwin";
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };

      mkDarwinConfig = { hostname, hostModule }: darwin.lib.darwinSystem {
        inherit system;
        specialArgs = { inherit pkgs-unstable; };
        modules = [
          ./configuration.nix
          ./lsp.nix
          ./cloud.nix
          ./utilities.nix
          ./fonts.nix
          home-manager.darwinModules.home-manager
          hostModule
        ];
      };

      mkHostModule = { username, extraCasks ? [], extraPackages ? [] }: { pkgs, ... }: {
        users.users.${username}.home = "/Users/${username}";
        homebrew.casks = extraCasks;
        home-manager = {
          useUserPackages = true;
          useGlobalPkgs = true;
          users.${username} = {
            home.stateVersion = "22.11";
            programs.home-manager.enable = true;
            home.packages = with pkgs; [ sops ] ++ extraPackages;
            home.enableNixpkgsReleaseCheck = false;
          };
        };
      };
    in
    {
      darwinConfigurations = {
        "AM-H6MRWRT99L" = mkDarwinConfig {
          hostname = "AM-H6MRWRT99L";
          hostModule = mkHostModule {
            username = "lmai";
            extraCasks = [ "aws-vpn-client" "brave-browser" ];
          };
        };

        "AS-CCW7VHW44G" = mkDarwinConfig {
          hostname = "AS-CCW7VHW44G";
          hostModule = mkHostModule {
            username = "lmai";
            extraCasks = [ "aws-vpn-client" "brave-browser" ];
          };
        };
      };
    };
}
