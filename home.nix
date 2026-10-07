{ config, pkgs, ... }:
let
  MSRV = "1.99.0";
  ZIG_VERSION = "0.16.0";
  GO_VERSION = "1.27.0";
  ODIN_VERSION = "dev-2026-09";
  OLS_VERSION = "dev-2026-08";
in
{
  home.stateVersion = "24.05";

  home.username = "ruahman";
  home.homeDirectory = "/home/ruahman";


  #xdg.configFile."zed/keymap.json".text = builtins.toJSON [
  #  {
  #      context = "Workspace";
  #      bindings = {
  #          "space p" = "project_panel::Toggle";
  #      };
  #  }
  #];

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [

    ## AI
    claude-code
    claude-agent-acp
    opencode
    pi-coding-agent
    omp

    ## AWS
    awscli2

    ## Containerization
    #colima  # container runtime selector
    #incus # LXC/LXD

    ## build tools
    bruno
    postman
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
    vlc

    ## office
    libreoffice

    ## text editors
    neovim
    #neovide

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
    vscode-extensions.vadimcn.vscode-lldb.adapter
    pkg-config
    (lib.lowPrio lldb)
    #jetbrains.rust-rover

    ## golang 
    go-bin.versions.${GO_VERSION}
    gopls
    (lib.lowPrio gotools)
    gofumpt
    golines
    delve
    golangci-lint
    #jetbrains.goland
 
    ## c/c++ 
    (lib.hiPrio clang)
    clang-tools
    gcc
    binutils 
    jetbrains.clion

    ## zig
    pkgs.zigpkgs.${ZIG_VERSION}
    zls

    ## odin
    odin-bin.${ODIN_VERSION}
    ols-bin.${OLS_VERSION}


    ## python
    python314
    python314Packages.pytest
    python314Packages.pip
    python314Packages.ipython
    python314Packages.numpy
    python314Packages.pandas
    python314Packages.matplotlib
    python314Packages.pyzmq
    python314Packages.jupyter
    python314Packages.marimo
    uv
    pipenv
    poetry
    mypy
    isort
    ruff
    pyright
    basedpyright
    #jetbrains.pycharm

    # mojo
    mojo-bin

    ## ruby, make ruby bundler is higher priority 
    ruby
    rubyPackages.nokogiri
    rubyPackages.pry
    rubyPackages.rubocop
    solargraph
    #jetbrains.ruby-mine

    ## javascript/typescript
    nodejs
    #fnm
    typescript
    tsx
    eslint
    prettier
    #nub
    typescript-language-server
    vscode-langservers-extracted
    vscode-js-debug
    playwright-driver.browsers
    #jetbrains.webstorm

    ## dotnet
    dotnet-sdk_10
    roslyn-ls # C# language server
    csharpier # C# code formatter
    avalonia
    jetbrains.rider

    ## terminals
    terminator

    ## browsers
    google-chrome
    #microsoft-edge

    #db
    sqlite
    postgresql
    #redis
    #mongodb-ce
    #couchdb3
    #jetbrains.datagrip

    ## utils/tools
    fastfetch
    htop
    lazygit 
    xclip # clipboard
    unzip
    wget
    ripgrep
    fd
    ispell
    pandoc
    imagemagick # image
    ffmpeg # video
    tree # show directory tree
    bat # cooler cat
    jq # json 
    yq-go # yaml 
    ueberzugpp # for showing pics in terminal
    just # make like tool
    watchexec # file watcher
    pavucontrol # volume control
    blueman # bluetooth control
    cloudsmith-cli
    #gnupg # good enough privacy

    # for neovim
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

    # dictionary
    hunspell
    hunspellDicts.en_US
    hunspellDicts.es_PR

    # security
    nmap
    dirb
    wireshark
    angryipscanner
  ];

  programs.emacs = {
    enable = true;
    package = pkgs.emacs;  # or pkgs.emacs-pgtk, pkgs.emacs-nox, etc.
  };

  services.emacs = {
    enable = true;
    defaultEditor = true;  # sets EDITOR/VISUAL to emacsclient
    client.enable = true;  # installs a desktop entry for emacsclient
  };


  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableNushellIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    enableNushellIntegration = true;
  };

  programs.eza = {
    enable = true;
  };

  programs.lf = {
    enable = true;
  };

  programs.vscode = {
    enable = true;
  };

  programs.zed-editor = {
    enable = true;
    userSettings = {
      vim_mode = true;
      relative_line_numbers = "enabled";
      format_on_save = "on";
      icon_theme = "Material Icon Theme";
      ui_font_size = 20;
      ui_font_family = "JetBrainsMono Nerd Font";
      buffer_font_size = 20;
      buffer_font_family = "JetBrainsMono Nerd Font";
      auto_update = false;
      extend_comment_on_newline = false;

      theme = {
        mode = "dark";
        light = "Tokyo Night Light";
        dark = "Tokyo Night";
      };
      title_bar = {
        show_menus = false;
        show_user_picture = false;
        show_user_menu = true;
        show_sign_in = false;
        show_onboarding_banner = false;
        show_project_items = true;
        show_worktree_name = false;
        show_branch_name = true;
      };
      toolbar = {
        quick_actions = false;
      };
      status_bar = {
        "experimental.show" = false;
      };
      project_panel = {
        dock = "right";
        default_width = 350.0;
      };
      agent = {
        dock = "right";
        sidebar_side = "right";
      };
      agent_servers = {
        "claude-code" = {
          type = "custom";
          command = "claude-agent-acp";
          args = [];
        };
        "omp" = {
          type = "custom";
          command = "omp";
          args = [ "acp" ];
        };
        "opencode" = {
          type = "custom";
          command = "opencode";
          args = [ "acp" ];
        };
      };
    };
  };

  programs.nushell = {
    enable = true;
    settings = {
      show_banner = false;
    };
    # statically evaluate env variables
    environmentVariables = {
      RUSTC_WRAPPER = "${pkgs.sccache}/bin/sccache";
      OPENSSL_DIR = "${pkgs.openssl.dev}";
      OPENSSL_LIB_DIR = "${pkgs.openssl.out}/lib";
      OPENSSL_INCLUDE_DIR = "${pkgs.openssl.dev}/include";
      PLAYWRIGHT_BROWSERS_PATH = "${pkgs.playwright-driver.browsers}";
      PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";
      PLAYWRIGHT_HOST_PLATFORM_OVERRIDE = "ubuntu-24.04";
      PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
   };
   shellAliases = {
    lsz = "eza -l --git --icons --tree --level=2";
   };
   extraConfig = ''
      def --env --wrapped lfcd [...args] {
        let dir = (^lf -print-last-dir ...$args | str trim)
        if ($dir | is-not-empty) and ($dir | path exists) {
          cd $dir
        }
      }
   '';
  };

  programs.bash = {
    enable = true;
  };

  programs.git = {
    enable = true;
  };
 
  programs.ghostty = {
    enable = true;
    settings = {
      #window-decoration = false;
      #fullscreen = true;

      theme = "Adventure Time";
      background-opacity = 0.85;
      
      font-family = "FiraCode Nerd Font";
      window-inherit-font-size = false;
      font-size = 18;

      window-height = 25;
      window-width = 100;
    };
  };

  programs.starship = {
    enable = true;
    enableNushellIntegration = true;
    enableBashIntegration = true;
    settings = {
      scan_timeout = 500;  # in milliseconds
      nodejs = {
        symbol = "󰎙 ";
      };
      python = {
        symbol = " ";
      };
      ruby = {
        symbol = " ";
      };
      golang = {
        symbol = " ";
      };
      rust = {
        symbol = " ";
      };
      zig = {
        symbol = " ";
      };
      lua = {
        symbol = " ";
      };
      dotnet = {
        symbol = " ";
      };
    };
  };


  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
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

  programs.herdr.enable = true;
  
}
