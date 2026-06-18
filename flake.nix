{
  description = "A simple NixOS flake";

  inputs = {

    # nix packages
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # home-manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # rust overlay
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      # so that rust-overlay uses the same nixpkgs
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    # zig overlay
    zig-overlay = {
      url = "github:mitchellh/zig-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    # go overlay
    go-overlay = {
      url = "github:purpleclay/go-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    # claude code
    claude-code-nix = {
      url = "github:sadjow/claude-code-nix";
	    inputs.nixpkgs.follows = "nixpkgs";
    };

    # neovim nightly
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, rust-overlay, zig-overlay, go-overlay, claude-code-nix, neovim-nightly-overlay, ... }@inputs: 
    let
      system = "x86_64-linux";

      overlays = [ 
	rust-overlay.overlays.default 
        zig-overlay.overlays.default
        go-overlay.overlays.default
        claude-code-nix.overlays.default
	neovim-nightly-overlay.overlays.default
      ];

      # Create a pkgs instance with overlays applied
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

          # our home manager config
          home-manager.users.ruahman = import ./home.nix;
        }
      ];
    };
  };
}
