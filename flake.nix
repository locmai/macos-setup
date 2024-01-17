{
  description = "Loc's macOS setup";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/3bf71cb5a36130f566bb6ae7574533db52403f00";
    };
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, darwin, home-manager }: {
    darwinConfigurations = {
      "lmac" = darwin.lib.darwinSystem {
        system = "x86_64-darwin";
        modules = [
          ./configuration.nix
          home-manager.darwinModules.home-manager
          ./home/personal.nix
        ];
        inputs = { inherit nixpkgs darwin home-manager; };
      };
       "SGN-CJKM3P2ND4" = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./configuration.nix
          home-manager.darwinModules.home-manager
          ./home/work.nix
        ];
        inputs = { inherit nixpkgs darwin home-manager; };
      };
 };
  };
}
