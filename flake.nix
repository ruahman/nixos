{
  description = "My NixOS flake";

  inputs = {

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mangowm = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mangobar = {
      url = "github:mangowm/mangobar";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    zig-overlay = {
      url = "github:mitchellh/zig-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    go-overlay = {
      url = "github:purpleclay/go-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    odin-overlay = {
      url = "github:ArMonarch/odin-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    claude-code-nix = {
      url = "github:sadjow/claude-code-nix";
	  inputs.nixpkgs.follows = "nixpkgs";
    };

    herdr-nix = {
      url = "github:herdrdev/herdr-nix"; # Or github:herdrdev/herdr
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvim-mcp = {
      url = "github:linw1995/nvim-mcp";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    claude-desktop-nix-flake = {
      url = "github:poeck/claude-desktop-nix-flake";
	  inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-vite-plus = {
      url = "github:ryoppippi/nix-vite-plus";
	  inputs.nixpkgs.follows = "nixpkgs";
    };

    nub-overlay = {
      url = "github:alleneubank/nub-overlay";
	  inputs.nixpkgs.follows = "nixpkgs";
    };

    artcraft = {
      url = "github:mahlquistj/artcraft-flake";  
	  inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, 
    nixpkgs, 
    mangowm,
    mangobar,
    nixvim,
    home-manager, 
    rust-overlay, 
    zig-overlay, 
    go-overlay, 
    odin-overlay, 
    claude-code-nix, 
    herdr-nix,
    nvim-mcp,
    claude-desktop-nix-flake,
    nix-vite-plus, 
    nub-overlay, 
    artcraft, ... }@inputs: 
    let
      system = "x86_64-linux";

      overlays = [ 
        # helix.overlays.default
	    rust-overlay.overlays.default 
        zig-overlay.overlays.default
        go-overlay.overlays.default
        odin-overlay.overlays.odin-overlays
        odin-overlay.overlays.ols-overlays
        claude-code-nix.overlays.default
        claude-desktop-nix-flake.overlays.default
        nix-vite-plus.overlays.default
        nub-overlay.overlays.default
        artcraft.overlays.default
        (final: prev: {
          herdr = herdr-nix.packages.${prev.system}.default;
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

      specialArgs = { inherit inputs; };

      modules = [
        ./configuration.nix
        # add mangowm to nixos
        mangowm.nixosModules.mango
        # add nixvim to nixos
        nixvim.nixosModules.nixvim
        # add home-manager to nixos
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";

          home-manager.extraSpecialArgs = { 
            inherit pkgs; 
            inherit inputs;
          };
          
          home-manager.sharedModules = [
            mangowm.hmModules.mango
            mangobar.homeManagerModules.default
            artcraft.homeModules.default
          ];

          home-manager.users.ruahman = import ./home.nix;
        }
      ];
    };
  };
}
