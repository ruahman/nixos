{ config, pkgs, ... }:

{
  home.stateVersion = "24.05";

  home.username = "ruahman";
  home.homeDirectory = "/home/ruahman";

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # utils
    #terminator
    google-chrome
    neofetch
    htop
    xclip
    unzip
    ripgrep
    fzf
    ispell
    tree
    bat
    jq

    # nix tools
    nix-prefetch-git
    node2nix

    # for neovim
    lua
    luarocks 
    nodejs

    # tools
    ranger
    bruno
    irssi

    # fonts
    nerd-fonts.fira-code
    nerd-fonts.caskaydia-cove
    nerd-fonts.jetbrains-mono
    nerd-fonts.hack
  ];

  programs.git = {
    enable = true;
    userName = "Diego R Vila";
    userEmail = "dego_vila@yahoo.com";
    extraConfig = {
      user = {
        signkey = "06F1C22CE653AEF5";
      };
      credential = {
        helper = "store";
      };
      commit = {
        gpgsign = "true";
      };
      safe = {
        directory = "/etc/nixos";
      };
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv = {
      enable = true;
    };
  };

  programs.terminator = {
    enable = true;
    config = {
      profiles.default.font = "FiraCode Nerd Font Regular 20";
    };
  };

  programs.kitty = {
    enable = true;
    font = {
      name = "FiraCode Nerd Font";
      size = 18.0;
    };
    settings = {
      shell = "${pkgs.nushell}/bin/nu";
    };
  };

  programs.nushell.enable = true;
  programs.starship.enable = true;
  programs.gpg.enable = true;
  programs.emacs.enable = true;
  programs.google-chrome.enable = true;
  programs.neovim.enable = true;
  programs.lazygit.enable = true;
  programs.tmux.enable = true;
}
