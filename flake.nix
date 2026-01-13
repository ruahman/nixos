{
  description = "A simple NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      # so that rust-overlay uses the same nixpkgs
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
  };

  outputs = { self, nixpkgs, home-manager, rust-overlay, ... }@inputs: 
    let
      system = "x86_64-linux";
      overlays = [ (import rust-overlay) ];

      # Create a pkgs instance with rust-overlay applied
      pkgs = import nixpkgs {
        inherit system overlays;
        config.allowUnfree = true;
      };
    in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs; }; # this is the important part

      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

	  # Pass the modified pkgs with rust-overlay to Home Manager
          home-manager.extraSpecialArgs = { inherit pkgs; };

          home-manager.users.ruahman = import ./home.nix;
        }
      ];
    };
  };
}
