{
  description = "Loc's macOS setup";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-24.11";
    };
    darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # home-manager = {
    #   url = "github:nix-community/home-manager";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    home-manager = {
      url = "github:nix-community/home-manager/0b491b460f52e87e23eb17bbf59c6ae64b7664c1";
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
      "lmac" = darwin.lib.darwinSystem {
        system = "x86_64-darwin";
        modules = [
          ./lsp.nix
          ./cloud.nix
          ./configuration.nix
          home-manager.darwinModules.home-manager
          ./home/personal.nix
        ];
        inputs = {inherit nixpkgs darwin home-manager;};
      };
      "AS-CJKM3P2ND4" = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./lsp.nix
          ./cloud.nix
          ./utilities.nix
          ./configuration.nix
          home-manager.darwinModules.home-manager
          ./home/work.nix
        ];
        inputs = {inherit nixpkgs darwin home-manager;};
      };
    };
  };
}
