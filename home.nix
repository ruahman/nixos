{
  config,
  pkgs,
  lib,
  ...
}:
let
  MSRV = "1.99.0"; # minimual supported rust version
  ZIG_VERSION = "0.17.0";
  GO_VERSION = "1.27.0";
  ODIN_VERSION = "dev-2026-10";
  OLS_VERSION = "dev-2026-08";
in
{
  home = {
    stateVersion = "26.05";
    username = "ruahman";
    homeDirectory = "/home/ruahman";
  };

  # import hardware configuration
  imports = [
    ./neovim/home.nix
    ./emacs/emacs.nix
    ./mangowm.nix
    ./ai.nix
  ];

  home.sessionVariables = {
    RUSTC_WRAPPER = "${pkgs.sccache}/bin/sccache";
    OPENSSL_DIR = "${pkgs.openssl.dev}";
    OPENSSL_LIB_DIR = "${pkgs.openssl.out}/lib";
    OPENSSL_INCLUDE_DIR = "${pkgs.openssl.dev}/include";
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
  };

  home.shellAliases = {
    lsz = "eza -l --git --icons --tree --level=2";
    nvim = "nvim --listen /tmp/nvim";
  };

  # xternal desktop group
  xdg.portal = {
    enable = true;

    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "*";
  };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [

    # a comandline tool for managing display and monitors
    # wlr-randr

    # file explorer
    thunar

    # bootstick burner
    caligula

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
    claude-agent-acp
    # opencode
    # omp
    voxtype # speach-to-text

    ## AWS
    awscli2

    ## Containerization
    podman
    podman-compose
    docker
    docker-compose
    lazydocker
    docker-language-server

    ## development tools
    bruno
    postman
    posting
    gnumake
    cmake
    glibc.dev
    openssl
    openssl.dev
    protobuf
    nasm
    asm-lsp
    taplo # toml tools

    ## bitcoin
    #bitcoind
    #lnd
    #sparrow

    ## paint
    pinta

    ## music and video
    #audacity
    vlc

    ## office
    #libreoffice
    foliate # epub

    ## math
    typst
    tinymist # typst lsp
    miktex # latex

    ## text editors
    # emacs

    ## email
    #evolution
    thunderbird

    ## torrent
    qbittorrent

    ## video games
    # snes9x

    # windows emulation
    wine
    bottles

    ## rust
    (rust-bin.stable.${MSRV}.default.override {
      extensions = [
        "rust-src" # Required for rust-analyzer
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
    gofumpt
    golines
    golangci-lint
    golangci-lint-langserver
    delve # golang debugger

    ## c/c++
    (lib.hiPrio clang)
    clang-tools
    gcc
    seer # gui debugger
    nnd # tui debugger
    binutils

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
    python314Packages.python-lsp-server
    python314Packages.jedi-language-server
    uv
    pipenv
    poetry
    mypy
    ty
    isort
    ruff
    pyright # python lsp
    basedpyright # python lsp
    pyenv

    ## ruby
    ruby
    rubyPackages.nokogiri
    rubyPackages.pry
    rubyPackages.rubocop
    solargraph
    ruby-lsp
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
    lazynpm
    typescript-language-server
    vscode-langservers-extracted
    superhtml
    vscode-js-debug
    jetbrains.webstorm
    fnm

    ## wasm
    wasmtime

    ## dotnet
    dotnet-sdk_11
    # roslyn-ls # C# language server
    omnisharp-roslyn # language server
    csharpier # C# code formatter
    # avalonia

    ## browsers
    google-chrome

    #db
    sqlite
    postgresql
    mariadb
    lazysql

    ## utils/tools
    fastfetch
    cmatrix
    htop
    btop
    below
    # superfile
    tldr # to long don't read
    duf # disk utility find
    delta # diff tool
    difftastic # diff tool
    pass # passwords
    # gopass
    yubikey-manager
    # lazygit
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
    # cloudsmith-cli
    #gnupg # good enough privacy

    # message apps
    telegram-desktop
    karere # opensource whatsapp
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

  programs = {
    helix = {
      enable = true;
      settings = {
        theme = "tokyonight";
        editor = {
          line-number = "relative";
          bufferline = "multiple";
          cursorline = true;
          cursor-shape = {
            normal = "block";
            insert = "bar";
            select = "underline";
          };
          indent-guides = {
            render = true;
            character = "│"; # Custom vertical line character
            skip-levels = 0; # Number of indent levels to skip rendering
          };
          statusline = {
            left = [
              "spinner"
              "mode"
              "read-only-indicator"
              "file-modification-indicator"
              "file-name"
              "version-control"
            ];
            center = [ "diagnostics" ];
            right = [
              "selections"
              "register"
              "position"
              "position-percentage"
              "file-encoding"
              "file-type"
            ];
          };
          lsp = {
            display-messages = true;
            display-inlay-hints = true;
          };
        };
        keys.insert = {
          "C-j" = "normal_mode";
          "C-f" = "move_char_right";
          "C-b" = "move_char_left";
          "C-n" = "move_line_down";
          "C-p" = "move_line_up";
        };
      };
      languages.language = [
        {
          name = "c-sharp";
          auto-format = true;
          formatter = {
            command = "csharpier";
            args = [ "format" ];
          };
        }
      ];
    };

    lazygit = {
      enable = true;
      settings.os = {
        openLink = "xdg-open {{link}}"; # used for "create pull request", open in browser, etc.
        open = "xdg-open {{filename}}"; # used for opening files ("o")
      };
    };

    zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableNushellIntegration = true;
    };

    # fuzy find
    fzf = {
      enable = true;
      enableBashIntegration = true;
      enableNushellIntegration = false;
    };

    eza.enable = true;

    yazi.enable = true;

    zed-editor = {
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
            args = [ ];
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

    nushell = {
      enable = true;
      settings = {
        show_banner = false;
      };
      environmentVariables = config.home.sessionVariables;
      loadSessionVariables = false;
      shellAliases = config.home.shellAliases;
    };

    bash.enable = true;

    zsh.enable = true;

    git.enable = true;

    ghostty = {
      enable = true;
      settings = {
        theme = "Adventure Time";
        background-opacity = 0.85;

        font-family = "FiraCode Nerd Font";
        window-inherit-font-size = false;
        font-size = 18;

        window-height = 25;
        window-width = 100;

        window-padding-balance = true;
        window-padding-color = "extend";
      };
    };

    terminator = {
      enable = true;
      config = {
        profiles.default = {
          use_system_font = false;
          font = "Terminess Nerd Font Mono 18";
        };
      };
    };

    kitty = {
      enable = true;
      font = {
        name = "CaskaydiaCove Nerd Font";
        size = 18;
        package = pkgs.nerd-fonts.jetbrains-mono;
      };
    };

    foot = {
      enable = true;
      settings = {
        main = {
          font = "JetBrainsMono Nerd Font:size=18";
        };
      };
    };

    starship = {
      enable = true;
      enableNushellIntegration = true;
      enableBashIntegration = true;
      settings = {
        scan_timeout = 500; # in milliseconds
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

    carapace = {
      enable = true;
      enableBashIntegration = true;
    };

    tmux = {
      enable = true;
      shell = "${pkgs.nushell}/bin/nu";
      terminal = "tmux-256color";
      extraConfig = ''
        set -g mouse on
        set-option -g status-position top
        set -g base-index 1
        set -g pane-base-index 1
        bind-key C-t if-shell -F '#{==:#{client_session},popup}' 'detach-client' 'display-popup -w 80% -h 75% -d "#{pane_current_path}" -E "tmux new-session -A -s popup"'
        set -g popup-style bg=default
        set -g popup-border-lines rounded
        set -as terminal-overrides ",*:Tc"
      '';
      plugins = with pkgs.tmuxPlugins; [
        {
          plugin = nord;
          extraConfig = ''
            set -g @nord_tmux_date_format "%Y-%m-%d"
            # set -g @nord_tmux_no_patched_font "1"   # if you don't use a Nerd Font
          '';
        }
        # tmux-powerline
        # {
        #   plugin = tmux-which-key;
        #   extraConfig = ''
        #     set -g @tmux-which-key-xdg-enable 1
        #   '';
        # }
        # {
        #   plugin = tokyo-night-tmux;
        #   extraConfig = ''
        #     set -g @tokyo-night-tmux_show_path 1
        #   '';
        # }
      ];
    };

    herdr = {
      enable = true;
      package = pkgs.herdr;
      settings = {
        onboarding = false;
        keys = {
          prefix = "ctrl+b";
        };
        theme = {
          name = "catppuccin";
        };
        terminal = {
          default_shell = "bash";
        };
        ui = {
          sound = {
            enabled = true;
          };
          toast = {
            delivery = "herdr";
          };
        };
      };
    };

    rofi = {
      enable = true;
      settings.terminal = "${pkgs.ghostty}/bin/ghostty";
      settings.extraConfig = {
        modi = "drun,run,window";
        show-icons = true;
        drun-display-format = "{name}";
      };
    };

    gridcraft.enable = true;
    wordcraft.enable = true;
    deckcraft.enable = true;
    pdfcraft.enable = true;
    photocraft.enable = true;
  };

}
