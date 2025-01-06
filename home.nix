{ config, pkgs, ... }:

{
  home.stateVersion = "24.05";

  home.username = "ruahman";
  home.homeDirectory = "/home/ruahman";

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # email
    thunderbird
    protonmail-bridge

    # paint
    drawing
    gimp
    inkscape

    # music
    audacity
    vlc

    # text editors
    neovim
    emacs30-pgtk
    zed-editor
    vscode

    # browsers
    google-chrome

    # bitcoin
    electrum
    sparrow

    # utils/tools
    lazygit
    zsh
    fish
    elvish
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
    ueberzugpp
    vscode-extensions.vadimcn.vscode-lldb
    #bruno

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
    vscode-langservers-extracted
    vscode-js-debug
    vscode-extensions.vadimcn.vscode-lldb

    # message apps
    telegram-desktop
    whatsapp-for-linux
    signal-desktop
    slack
    #zoom-us
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

    "Pictures/wallpapers".source = ./.wallpapers;

    ".config/ghostty/config".text = ''
      window-decoration = false

      theme = AdventureTime
      background-opacity = 0.85
      
      font-family = "JetBrainsMono Nerd Font"
      window-inherit-font-size = false
      font-size = 16
    '';
  };

  programs.home-manager.enable = true;

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

  programs.neovide = {
    enable = true;
    settings = {
      font = {
        normal = ["FiraCode Nerd Font"];
        size = 14.0;
      };
    };
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
      lua = {
        symbol = " ";
        style = "bold #00007F";
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
