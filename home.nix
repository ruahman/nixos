{ config, pkgs, ... }:

{
  home.stateVersion = "24.05";

  home.username = "ruahman";
  home.homeDirectory = "/home/ruahman";

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # email
    thunderbird

    # paint
    drawing

    # text editors
    neovide
    neovim
    emacs30-pgtk
    zed-editor
    vscode

    # browsers
    google-chrome

    # utils/tools
    zsh
    zellij
    neofetch
    fastfetch
    cpufetch
    cmatrix
    htop
    btop
    stacer
    wireshark
    angryipscanner
    gdu
    teller
    xclip
    trashy
    entr
    eza
    lsd
    rnr
    tldr
    cheat
    unzip
    wget
    ripgrep
    fd
    fzf
    delta
    ispell
    pandoc
    imagemagick
    gimp
    inkscape
    ffmpeg
    vlc
    pdfcpu
    tree
    bat
    jq
    yq
    jqp
    jless
    htmlq
    difftastic
    ranger
    yazi
    ueberzugpp
    bruno

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

    # message apps
    telegram-desktop
    whatsapp-for-linux
    signal-desktop
    slack
    zoom-us
    discord
    irssi
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
      name = "terminus";
      size = 16.0;
    };
    settings = {
      shell = "${pkgs.nushell}/bin/nu";
      background_opacity = 0.9;
    };
  };

  programs.nushell = {
    enable = true;
    extraConfig = ''
      $env.config.show_banner = false
    '';
  };

  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };

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

  programs.tmux = {
    enable = true;
    plugins = with pkgs; [
      tmuxPlugins.catppuccin
      tmuxPlugins.tmux-fzf
    ];
    extraConfig = ''
      set -g mouse on
      set-option -g status-position top
      set -g base-index 1
    ''; 
  };
}
