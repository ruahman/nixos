{ config, pkgs, ... }:

{
  home.stateVersion = "24.05";

  home.username = "ruahman";
  home.homeDirectory = "/home/ruahman";

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # utils
    neofetch
    htop
    xclip
    unzip
    wget
    ripgrep
    fd
    fzf
    ispell
    tree
    bat
    jq

    # nix tools
    nix-prefetch-git
    node2nix

    # for neovim
    lua51Packages.lua
    lua51Packages.luarocks
    lua51Packages.luacheck
    lua-language-server
    stylua
    vscode-langservers-extracted
    vscode-js-debug
    vscode-extensions.vadimcn.vscode-lldb

    # tools
    ranger
    bruno
    irssi

    telegram-desktop
    slack
    signal-desktop
    whatsapp-for-linux
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
      init = {
          defaultBranch = "main";
      };
      core = {
          editor = "nano";
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
      size = 16.0;
    };
    settings = {
      shell = "${pkgs.nushell}/bin/nu";
      background_opacity = 0.9;
    };
  };

  programs.nushell.enable = true;
  programs.starship = {
    enable = true;
    settings = {
      time = {
        disabled = false;
      };
      nodejs = {
        symbol = " ";
        style = "bold #54a245";
      };
      rust = {
        symbol = "󱘗 ";
        style = "bold #f7931a";
      };
      bun = {
        symbol = " ";
        style = "bold #f9f1e1";
      };
    };
  };
  programs.gpg.enable = true;
  programs.emacs.enable = true;
  programs.google-chrome.enable = true;
  programs.neovim.enable = true;
  programs.lazygit.enable = true;
  programs.tmux.enable = true;
}
