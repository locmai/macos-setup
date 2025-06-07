{
  description = "Loc's macOS setup";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-25.05";
    };
    darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    darwin,
    home-manager,
  }: {
    darwinConfigurations = {
      "AS-CJKM3P2ND4" = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./lsp.nix
          ./cloud.nix
          ./utilities.nix
          ./configuration.nix
          ./fonts.nix
          home-manager.darwinModules.home-manager
          ./home/work.nix
        ];
        inputs = {inherit nixpkgs darwin home-manager;};
      };
    };
  };
}
