{ config, pkgs, ... }:
let
  MSRV = "1.86.0";
  ZIG_VERSION = "0.15.2";
  GO_VERSION = "1.25.5";
in
{
  home.stateVersion = "24.05";

  home.username = "ruahman";
  home.homeDirectory = "/home/ruahman";

  # home.sessionVariables = {
  #     RUSTC_WRAPPER = "${pkgs.sccache}/bin/sccache";
  #     PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig:$PKG_CONFIG_PATH";
  #     OPENSSL_DIR = "${pkgs.openssl.dev}";
  #     OPENSSL_LIB_DIR = "${pkgs.openssl.out}/lib";
  #     OPENSSL_INCLUDE_DIR = "${pkgs.openssl.dev}/include";
  #     PLAYWRIGHT_BROWSERS_PATH = "${pkgs.playwright-driver.browsers}";
  #     PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";
  #     PLAYWRIGHT_HOST_PLATFORM_OVERRIDE = "ubuntu-24.04";
  # };

  # xdg.configFile."bitcoin/bitcoin.conf".text = ''
  #   # Run on the local regression test network
  #   regtest=1
  #   server=1
  #   txindex=1
  #
  #   [regtest]
  #   rpcuser=admin
  #   rpcpassword=password
  #   # Regtest default port is 18443
  #   rpcbind=127.0.0.1
  #   rpcallowip=127.0.0.1
  #
  #   # Optional: allow deprecated calls often used in dev
  #   deprecatedrpc=create_deterministic_wallets
  # '';

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [

    ##
    claude-code
    claude-agent-acp
    opencode
    codex

    ## Containerization
    #colima  # container runtime selector
    #incus # LXC/LXD
    podman
    podman-compose
    docker 
    docker-compose

    ## build tools
    gnumake 
    cmake 
    glibc.dev 
    openssl
    openssl.dev
    protobuf
    nasm

    ## bitcoin
    #bitcoind
    #lnd
    #sparrow

    ## paint
    drawing
    #gimp
    #inkscape

    ## music and video
    #audacity
    #vlc

    ## office
    libreoffice

    ## notes
    #anytype

    ## text editors
    neovim
    emacs
    vscode
    #jetbrains-toolbox

    ## email
    evolution

    ## rust
    (rust-bin.stable.${MSRV}.default.override {
      extensions = [
        "rust-src"      # Required for rust-analyzer
        "rust-analyzer" # LSP server for IDEs
      ];
    })
    rust-script
    sccache
    jetbrains.rust-rover
    vscode-extensions.vadimcn.vscode-lldb.adapter
    pkg-config

    ## golang 
    go-bin.versions.${GO_VERSION}
    gopls
    delve
    golangci-lint
    jetbrains.goland
 
    ## c/c++ 
    jetbrains.clion
    #clang
    #clang-tools
    gcc
    binutils 

    ## zig
    pkgs.zigpkgs.${ZIG_VERSION}
    zls

    ## python
    pyright
    (pkgs.python313.withPackages (ps: with ps; [
      ipython
      pytest
      requests
      numpy
      pandas
      matplotlib
      jupyterlab 
      marimo
      flask
      mypy
      ruff
      isort
      pip
      pipenv
    ]))
    jetbrains.pycharm

    ## ruby 
    (ruby.withPackages (ps: with ps; [
      nokogiri
      pry
      bundler
      solargraph
    ]))
    jetbrains.ruby-mine

    ## javascript/typescript
    nodejs
    typescript
    tsx
    eslint
    prettier
    typescript-language-server
    vscode-langservers-extracted
    vscode-js-debug
    jetbrains.webstorm
    playwright-driver.browsers

    ## dotnet
    dotnet-aspnetcore

    ## terminals
    ghostty
    terminator

    ## browsers
    google-chrome
    microsoft-edge

    #db
    sqlite
    jetbrains.datagrip

    ## utils/tools
    lazygit 
    nushell

    htop
    #wireshark
    #angryipscanner
    xclip # clipboard
    unzip
    wget
    ripgrep
    fd
    fzf
    ispell
    pandoc
    imagemagick # image
    ffmpeg # video
    tree # show directory tree
    bat # cooler cat
    jq # json 
    yq-go # yaml 
    ueberzugpp # for showing pics in terminal
    #httpie # rest testing tool for console
    #httpie-desktop # rest desktop tool
    postman
    just
    watchexec # file watcher
    #gnupg
    pavucontrol # volume control
    blueman # bluetooth control
    cloudsmith-cli

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
    karere
    signal-desktop
    slack
    discord
    irssi

    zoom-us
    
  ];

  #home.shellAliases = {
  #  bitcoin-cli = "bitcoin-cli -conf=${config.xdg.configHome}/bitcoin/bitcoin.conf -regtest";
  #  bitcoind = "bitcoind -conf=${config.xdg.configHome}/bitcoin/bitcoin.conf";
  #};

  
  programs.bash = {
    enable = true;
    initExtra = ''
      export RUSTC_WRAPPER=${pkgs.sccache}/bin/sccache;
      export PKG_CONFIG_PATH=${pkgs.openssl.dev}/lib/pkgconfig:$PKG_CONFIG_PATH;
      export OPENSSL_DIR="${pkgs.openssl.dev}";
      export OPENSSL_LIB_DIR="${pkgs.openssl.out}/lib";
      export OPENSSL_INCLUDE_DIR="${pkgs.openssl.dev}/include";
      export PLAYWRIGHT_BROWSERS_PATH="${pkgs.playwright-driver.browsers}";
      export PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS="true";
      export PLAYWRIGHT_HOST_PLATFORM_OVERRIDE="ubuntu-24.04";
    '';
  };

  #programs.nushell = {
  #  enable = true;
  #  # Optional: Custom config/env.nu settings
  #  configFile.source = ''
  #    # Your custom config.nu content here
  #  '';
  #  envFile.source = ''
  #    # Custom env.nu for PATH, aliases, etc.
  #    $env.config = {
  #      show_banner: false
  #    }
  #  '';
  #};

  programs.git = {
    enable = true;
    #userName = "Diego R Vila";
    #userEmail = "dego_vila@yahoo.com";
    settings = {
      user = {
        name = "Diego R vila";
        email = "dego_vila@yahoo.com";
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

  #programs.direnv = {
  #  enable = true;
  #  silent = true;
  #  enableBashIntegration = true;
  #  nix-direnv = {
  #    enable = true;
  #  };
  #};

 
  programs.ghostty = {
    settings = {
      window-decoration = false;

      theme = "Adventure Time";
      background-opacity = 0.85;
      
      font-family = "JetBrainsMono Nerd Font";
      window-inherit-font-size = false;
      font-size = 18;
    };
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
