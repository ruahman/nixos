{ config, pkgs, ... }:

{
  home.stateVersion = "24.05";

  home.username = "ruahman";
  home.homeDirectory = "/home/ruahman";

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    #thunderbird # email

    # paint
    drawing
    gimp
    inkscape

    # music and video
    audacity
    vlc

    # office
    libreoffice
    
    # typst
    typst

    # notes
    obsidian

    # text editors
    neovim
    emacs30-pgtk
    zed-editor
    vscode

    # terminals
    ghostty
    kitty
    terminator
    termite

    # browsers
    google-chrome

    #db
    sqlitebrowser

    # bitcoin
    #bitcoind
    #lnd
    sparrow

    # android 
    android-studio

    # rust-rover 
    jetbrains.rust-rover

    # utils/tools
    lsof
    lazygit # git
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
    github-desktop # gui client for git

    # nix tools
    nix-prefetch-git
    prefetch-npm-deps
    node2nix

    # for neovim
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

  # for virt-manager
  #dconf.settings = {
  #  "org/virt-manager/virt-manager/connections" = {
  #    autoconnect = ["qemu:///system"];
  #    uris = ["qemu:///system"];
  #  };
  #};

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

      theme = "AdventureTime";
      background-opacity = 0.85;
      
      font-family = "JetBrainsMono Nerd Font";
      window-inherit-font-size = false;
      font-size = 18;
      
      #keybind = [
      #  "ctrl+x=close_tab"
      #];
    };
  };

  programs.kitty = {
    enable = true;
    font = {
      name = "FiraCode Nerd Font";
      size = 20.0;
    };
    settings = {
      #shell = "${pkgs.nushell}/bin/nu";

      # basic colors
      foreground =  "#c6d0f5";
      background =  "#303446";
      background_opacity = 0.9;
      selection_foreground = "#303446";
      selection_background = "#f2d5cf";

      # Cursor colors
      cursor = "#f2d5cf";
      cursor_text_color = "#303446";

      # URL underline color when hovering with mouse
      url_color = "#f2d5cf";
      
      # Kitty window border colors
      active_border_color = "#babbf1";
      inactive_border_color = "#737994";
      bell_border_color = "#e5c890";

      # OS Window titlebar colors
      wayland_titlebar_color = "system";
      macos_titlebar_color =  "system";

      # Tab bar colors
      active_tab_foreground = "#232634";
      active_tab_background = "#ca9ee6";
      inactive_tab_foreground = "#c6d0f5";
      inactive_tab_background = "#292c3c";
      tab_bar_background = "#232634";

      # Colors for marks (marked text in the terminal)
      mark1_foreground = "#303446";
      mark1_background = "#babbf1";
      mark2_foreground = "#303446";
      mark2_background = "#ca9ee6";
      mark3_foreground = "#303446";
      mark3_background = "#85c1dc";

      # The 16 terminal colors
      
      # black
      color0 = "#51576d";
      color8 = "#626880";
      
      # red
      color1 = "#e78284";
      color9 = "#e78284";
      
      # green
      color2 =  "#a6d189";
      color10 = "#a6d189";
      
      # yellow
      color3 =  "#e5c890";
      color11 = "#e5c890";
      
      # blue
      color4 =  "#8caaee";
      color12 = "#8caaee";
      
      # magenta
      color5 =  "#f4b8e4";
      color13 = "#f4b8e4";
      
      # cyan
      color6 =  "#81c8be";
      color14 = "#81c8be";
      
      # white
      color7 =  "#b5bfe2";
      color15 = "#a5adce";
    };
  };

  programs.terminator = {
    enable = true;
    config = {
      profiles.default.use_system_font = false;
      profiles.default.font = "Terminess Nerd Font 20";
    };
  };

  programs.termite = {
    enable = true;
    font = "Hack Nerd Font 20";
  };

  programs.nushell = {
    enable = true;
    extraConfig = ''
      $env.config.show_banner = false
      def --env y [...args] {
	let tmp = (mktemp -t "yazi-cwd.XXXXXX")
	yazi ...$args --cwd-file $tmp
	let cwd = (open $tmp)
	if $cwd != "" and $cwd != $env.PWD {
		cd $cwd
	}
	rm -fp $tmp
      }
    '';
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
    #plugins = with pkgs; [
    #  tmuxPlugins.catppuccin
    #  tmuxPlugins.power-theme
    #];
    extraConfig = ''
      set-option -g default-shell ${pkgs.bash}/bin/bash
      set -g mouse on
      set-option -g status-position top
      set -g base-index 1
    ''; 
  };
  
  programs.yazi = {
    enable = true;
    settings = { 
      manager = {
        linemode = "size";
        show_hidden = true;
	show_symlink = true;
      };
    };
  };
}
