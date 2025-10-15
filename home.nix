{ config, pkgs, ... }:

{
  home.stateVersion = "24.05";

  home.username = "ruahman";
  home.homeDirectory = "/home/ruahman";

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [

    ## Containerization
    colima  # container runtime selector
    incus # LXC/LXD
    podman
    podman-compose
    docker 
    docker-compose

    ## build tools
    gcc
    gnumake 
    cmake 
    binutils 
    glibc.dev 
    pkg-config
    nasm
    fasm

    ## bitcoin
    bitcoind
    lnd
    sparrow

    ## paint
    drawing
    gimp
    inkscape

    ## music and video
    audacity
    vlc

    ## office
    libreoffice

    ## notes
    anytype

    ## text editors
    neovim
    emacs30-pgtk
    zed-editor
    vscode
    jetbrains.rust-rover

    # rust
    rust-bin.stable."1.86.0".default
    rust-analyzer
    sqlite
    openssl
    pkg-config
    protobuf
    #clippy
    

    cloudsmith-cli

    ## terminals
    ghostty
    kitty
    terminator

    ## browsers
    google-chrome

    #db
    sqlitebrowser

    # utils/tools
    lsof
    lazygit 
    neofetch
    fastfetch
    cpufetch
    cmatrix
    htop
    btop
    #stacer
    wireshark
    angryipscanner
    gdu
    teller
    xclip # clipboard
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
    imagemagick # image
    ffmpeg # video
    pdfcpu
    tree # show directory tree
    bat # cooler cat
    jq # json 
    yq-go # yaml 
    jqp
    jless
    htmlq
    difftastic
    ueberzugpp # for showing pics in terminal
    bruno # api testing tool
    httpie # rest testing tool for console
    httpie-desktop # rest desktop tool
    just # new make tool
    watchexec # file watcher
    github-desktop # gui client for git
    gnupg
    pavucontrol # volume control
    blueman # bluetooth control

    ## nix tools
    nix-prefetch-git
    prefetch-npm-deps
    node2nix

    # for neovim
    hunspellDicts.es_PR
    lua51Packages.lua
    lua51Packages.luarocks
    lua51Packages.luacheck
    lua-language-server
    stylua
    tree-sitter

    # message apps
    telegram-desktop
    whatsapp-for-linux
    signal-desktop
    slack
    discord
    irssi
    
  ];

  home.file = {
    ".config/hypr/hyprland.conf".source = ./.dotfiles/hypr/hyprland.conf; 
    ".config/hypr/mocha.conf".source = ./.dotfiles/hypr/mocha.conf; 
    ".config/hypr/hyprpaper.conf".source = ./.dotfiles/hypr/hyprpaper.conf; 
    ".config/hypr/hyprlock.conf".source = ./.dotfiles/hypr/hyprlock.conf; 
    ".config/hypr/hypridle.conf".source = ./.dotfiles/hypr/hypridle.conf; 

    ".config/waybar".source = ./.dotfiles/waybar;
  };

  home.sessionVariables = {
  };


  #programs.home-manager.enable = true;

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
    silent = true;
    enableBashIntegration = true;
    nix-direnv = {
      enable = true;
    };
  };

  programs.bash = {
    enable = true;
    initExtra = ''
      export EDITOR="vim"
    '';
  };
 
  programs.ghostty = {
    enable = true;
    settings = {
      window-decoration = false;

      theme = "Adventure Time";
      background-opacity = 0.85;
      
      font-family = "JetBrainsMono Nerd Font";
      window-inherit-font-size = false;
      font-size = 18;
    };
  };

  programs.terminator = {
    enable = true;
    config = {
      profiles.default.use_system_font = false;
      profiles.default.font = "Terminess Nerd Font 20";
    };
  };

  programs.carapace = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.starship = {
    enable = true;
    settings = {
      time = {
        disabled = false;
      };
      c = {
        symbol = " ";
        style = "bold #005697";
      };
      nodejs = {
        symbol = " ";
        style = "bold #54a245";
      };
      rust = {
        symbol = "󱘗 ";
        style = "bold #f7931a";
      };
      golang = {
        symbol = " ";
        style = "bold #79D4FD";
      };
      bun = {
        symbol = " ";
        style = "bold #f9f1e1";
      };
      lua = {
        symbol = " ";
        style = "bold #00007F";
      };
      python = {
        symbol = " ";
        style = "bold #FFDF5A";
      };
      zig = {
        symbol = " ";
        style = "bold #F7A41D";
      };
    };
    enableBashIntegration = true;
  };

  programs.tmux = {
    enable = true;
    extraConfig = ''
      set-option -g default-shell ${pkgs.bash}/bin/bash
      set -g mouse on
      set-option -g status-position top
      set -g base-index 1
      set -g pane-base-index 1
    ''; 
  };
  
}
