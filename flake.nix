{
  description = "A simple NixOS flake";

  inputs = {

    # nix packages
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # mango windows manager
    mangowm = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

    # odin overlay
    odin-overlay = {
      url = "github:ArMonarch/odin-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    # claude code
    claude-code-nix = {
      url = "github:sadjow/claude-code-nix";
	  inputs.nixpkgs.follows = "nixpkgs";
    };
    
    claude-desktop-nix-flake = {
      url = "github:poeck/claude-desktop-nix-flake";
	  inputs.nixpkgs.follows = "nixpkgs";
    };

    # vite+
    nix-vite-plus = {
      url = "github:ryoppippi/nix-vite-plus";
	  inputs.nixpkgs.follows = "nixpkgs";
    };

    # nub
    nub-overlay = {
      url = "github:alleneubank/nub-overlay";
	  inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, 
    nixpkgs, 
    mangowm,
    home-manager, 
    rust-overlay, 
    zig-overlay, 
    go-overlay, 
    odin-overlay, 
    claude-code-nix, 
    claude-desktop-nix-flake,
    nix-vite-plus, 
    nub-overlay, ... }@inputs: 
    let
      system = "x86_64-linux";

      overlays = [ 
	    rust-overlay.overlays.default 
        zig-overlay.overlays.default
        go-overlay.overlays.default
        odin-overlay.overlays.odin-overlays
        odin-overlay.overlays.ols-overlays
        claude-code-nix.overlays.default
        claude-desktop-nix-flake.overlays.default
        nix-vite-plus.overlays.default
        nub-overlay.overlays.default
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
        # add mangowm to nixos
        mangowm.nixosModules.mango
        # add home-manager to nixos
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;


	  # Pass the modified pkgs with rust-overlay to Home Manager
          home-manager.extraSpecialArgs = { inherit pkgs; };
            
          
          home-manager.sharedModules = [
            # allow home-manager to configure mangowm
            mangowm.hmModules.mango
          ];

          # our home manager config
          home-manager.users.ruahman = import ./home.nix;
        }
      ];
    };
  };
}
