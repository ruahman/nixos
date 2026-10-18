{ config, pkgs, lib, inputs, ... }:
let
  MSRV = "1.99.0"; # minimual supported rust version
  ZIG_VERSION = "0.16.0";
  GO_VERSION = "1.27.0";
  ODIN_VERSION = "dev-2026-09";
  OLS_VERSION = "dev-2026-08";
  workspaceBinds = lib.concatMap (n: [
    "SUPER,${toString n},view,${toString n}"
    "SUPER+SHIFT,${toString n},tag,${toString n}"
  ]) (lib.range 1 9);
in
{
  home.stateVersion = "24.05";

  home.username = "ruahman";
  home.homeDirectory = "/home/ruahman";
  
  home.sessionVariables = {
      RUSTC_WRAPPER = "${pkgs.sccache}/bin/sccache";
      OPENSSL_DIR = "${pkgs.openssl.dev}";
      OPENSSL_LIB_DIR = "${pkgs.openssl.out}/lib";
      OPENSSL_INCLUDE_DIR = "${pkgs.openssl.dev}/include";
      PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
      PLAYWRIGHT_BROWSERS_PATH = "${pkgs.playwright-driver.browsers}";
      PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";
  };

  home.shellAliases = {
    lsz = "eza -l --git --icons --tree --level=2";
    httpie = "^http";
    httpies = "^https";
  };

  xdg.portal.enable = lib.mkForce true;

  xdg.portal = {
    extraPortals = [ pkgs.xdg-desktop-portal-gnome pkgs.xdg-desktop-portal-gtk ];
    config.niri.default = [ "gnome" "gtk" ];
  };

  home.pointerCursor = {
    enable = true;
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
   
    # bootstick burner
    caligula 

    # xfce
    xfce4-whiskermenu-plugin
    xfce4-dict
    xfce4-notes-plugin
    plank

    # mangowm
    swaybg # background
    swaynotificationcenter # notifications
    xdg-desktop-portal-wlr # screen shots?
    wl-clipboard
    cliphist
    grim
    gnome-keyring # for storing passwords

    ## AI
    claude-desktop
    claude-code
    claude-agent-acp
    opencode
    pi-coding-agent
    omp
    voxtype # speach-to-text

    ## AWS
    awscli2

    ## Containerization
    podman
    podman-compose
    docker 
    docker-compose
    lazydocker
    oxker

    ## development tools
    bruno
    bruno-cli
    httpie-desktop
    httpie
    postman
    posting
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
    pinta
    #gimp
    #inkscape

    ## music and video
    #audacity
    vlc

    ## office
    #libreoffice

    ## math
    typst
    miktex

    ## text editors
    neovim
    neovide
    helix

    ## email
    evolution

    ## torrent
    qbittorrent

    ## video games
    snes9x
    chess-tui

    # windows emulation
    wine
    bottles

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

    ## golang 
    go-bin.versions.${GO_VERSION}
    gopls
    (lib.lowPrio gotools)
    gofumpt
    golines
    delve
    golangci-lint
 
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
    pyenv

    # mojo
    mojo-bin

    ## ruby, make ruby bundler is higher priority 
    ruby
    rubyPackages.nokogiri
    rubyPackages.pry
    rubyPackages.rubocop
    solargraph
    rbenv

    ## javascript/typescript
    nodejs
    pnpm
    typescript
    tsx
    eslint
    prettier
    bun
    deno
    vite-plus
    nub
    playwright-driver.browsers
    typescript-language-server
    vscode-langservers-extracted
    vscode-js-debug
    jetbrains.webstorm
    fnm

    ## wasm
    wasmtime

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

    #db
    sqlite
    postgresql
    mariadb
    dblab
    lazysql
    #redis
    #mongodb-ce
    #couchdb3

    ## utils/tools
    fastfetch
    cmatrix
    htop
    btop
    below
    superfile
    yazi
    ranger
    tldr # to long don't read
    duf  # disk utility find
    delta # diff
    pass # passwords
    lazygit 
    xclip # clipboard
    p7zip # 7zip compression
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
    # package = pkgs.emacs-pgtk;  
  };

  services.emacs = {
    enable = true;
    defaultEditor = true;  # sets EDITOR/VISUAL to emacsclient
    client.enable = true;  # installs a desktop entry for emacsclient
  };

  # start emacs only after the graphical session (and its env import) is up
  # systemd.user.services.emacs = {
  #   Unit.After = [ "graphical-session.target" ];
  #   Unit.Wants = [ "graphical-session.target" ];
  # };


  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableNushellIntegration = true;
  };

  # fuzy find
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

  # programs.vscode = {
  #   enable = true;
  # };

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
    environmentVariables = config.home.sessionVariables;
    shellAliases = config.home.shellAliases;
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

  programs.zsh = {
    enable = true;
  };

  programs.git = {
    enable = true;
  };
 
  programs.ghostty = {
    enable = true;
    settings = {
      theme = "Adventure Time";
      background-opacity = 0.85;
      
      font-family = "FiraCode Nerd Font";
      window-inherit-font-size = false;
      font-size = 18;

      window-height = 25;
      window-width = 100;
    };
  };

  programs.terminator = {
    enable = true;
    config = {
      profiles.default = {
        use_system_font = false;
        font = "Terminess Nerd Font Mono 18";
      };
    };
  };

  # programs.kitty.enable = true;

  # programs.foot.enable = true;
  programs.kitty.enable = true;
  programs.kitty.font = {
    name = "CaskaydiaCove Nerd Font";
    size = 18;
    package = pkgs.nerd-fonts.jetbrains-mono;
  };

  programs.foot.enable = true;
  programs.foot.settings = {
    main = {
      font = "JetBrainsMono Nerd Font:size=18";
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

  wayland.windowManager.mango = {
    enable = true;

    settings = {
      xkb_rules_layout = "us";
      xkb_rules_variant = "intl";
      xkb_rules_options = "ctrl:nocaps";
      bind = [
        # Launchers
        "ALT,Return,spawn,foot"
        "ALT,g,spawn,ghostty"
        "ALT,e,spawn,emacsclient -c -n"
        "ALT,space,spawn,rofi -show drun"

        # Window management
        "ALT,q,killclient"
        "SUPER,m,quit"
        "SUPER,r,reload_config"
        "SUPER,f,togglefullscreen"

        # Set specific layout
        "SUPER,t,setlayout,tile"
        "SUPER,g,setlayout,grid"
        "SUPER,s,setlayout,scroller"

        # screen shot
        #"Print,spawn_shell,grim $HOME/Pictures/Screenshots/$(date +%Y%m%d%H%M%S).png"

        # Focus with arrow keys
        "ALT,Left,focusdir,left"
        "ALT,Right,focusdir,right"
        "ALT,Up,focusdir,up"
        "ALT,Down,focusdir,down"
        "SUPER,Left,viewtoleft,0"
        "SUPER,Right,viewtoright,0"
      ] ++ lib.concatMap (n: [
        "SUPER,${toString n},view,${toString n}"
        "SUPER+SHIFT,${toString n},tag,${toString n}"
      ]) (lib.range 1 9);

      exec_once = [
        "mangobar"
        "swaybg -i /home/ruahman/Pictures/wallhaven-p9pd23_1920x1080.png -m fill"
        "swaync"
        "wl-clipboard"
        "grim"
      ];

    };

  };

  services.mangobar = {
    enable = true;
    systemdTarget = "mango.target";
    settings = {
      modules-left = [ "workspaces" "layout" "window" ];
      modules-right = [ "custom/ssid" "custom/wifi" "cpu" "memory" "battery" "clock#date" "clock#time" ];
      "custom/ssid" = {
        exec = ''nmcli -t -f ACTIVE,SSID dev wifi | awk -F: '$1=="yes"{print $2}' '';
        interval = 10;
        format = "󰖩 {}";
      };
      "custom/wifi" = {
        exec = ''nmcli -t -f IN-USE,SIGNAL dev wifi | awk -F: '$1=="*"{print $2"%"}' '';
        interval = 10;
        format = "{}";
      };
      "clock#date" = {
        format = " {:L%b%d·%A}";
      };
      "clock#time" = {
        format = " {:L%I:%M %p}";
      };
    };
  };

  programs.rofi = {
    enable = true;
    terminal = "${pkgs.ghostty}/bin/ghostty";
    extraConfig = {
      modi = "drun,run,window";
      show-icons = true;
      drun-display-format = "{name}";
    };
  };

  
}
