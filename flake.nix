{
  description = "Loc's macOS setup";

  inputs = {
    nixpkgs = { url = "github:nixos/nixpkgs/nixos-25.11"; };
    nixpkgs-unstable = { url = "github:nixos/nixpkgs/nixpkgs-unstable"; };
    darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, darwin, home-manager, }: {
    darwinConfigurations = {
      "AM-H6MRWRT99L" = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = {
          pkgs-unstable = import nixpkgs-unstable {
            system = "aarch64-darwin";
            config.allowUnfree = true;
          };
        };
        modules = [
          ./lsp.nix
          ./cloud.nix
          ./utilities.nix
          ./configuration.nix
          ./fonts.nix
          home-manager.darwinModules.home-manager
          ./hosts/AM-H6MRWRT99L.nix
        ];
        inputs = { inherit nixpkgs darwin home-manager; };
      };
    };
  };
}
