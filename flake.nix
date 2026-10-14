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
        # Temporary fix for the typescript-language-server hash mismatch
        (final: prev: {
          typescript-language-server = prev.typescript-language-server.overrideAttrs (old: {
            pnpmDeps = old.pnpmDeps.overrideAttrs (_: {
              outputHash = "sha256-xR/EF60lVBsITKgH7wCM2wHM46PFQevD51KfCENSUH4=";  # paste the "got:" hash from your own terminal
            });
          });
        })
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
