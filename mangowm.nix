{ config, pkgs, ... }: {

  wayland.windowManager.mango = {
    enable = true;

    settings = {
      xkb_rules_layout = "us";
      xkb_rules_variant = "altgr-intl";
      xkb_rules_options = "ctrl:nocaps";
      bind = [
        # Launchers
        "ALT,t,spawn,foot"
        "ALT+SHIFT,t,spawn,ghostty"
        "ALT+SHIFT,f,spawn,thunar"
        "ALT,space,spawn,rofi -show drun"

        # Window management
        "ALT,q,killclient"
        "SUPER,m,quit"
        # "SUPER,r,reload_config"
        "SUPER,f,togglefullscreen"

        # Set specific layout
        "SUPER,t,setlayout,tile"
        "SUPER,g,setlayout,grid"
        "SUPER,s,setlayout,scroller"

        # screen shot
        "NONE,Print,spawn,sh -c 'grim \"$HOME/Pictures/Screenshots/$(date +%Y%m%d%H%M%S).png\"'"

        # lock screen
        "SUPER+SHIFT,l,spawn,swaylock"

        # Focus with arrow keys
        "ALT,Left,focusdir,left"
        "ALT,Right,focusdir,right"
        "ALT,Up,focusdir,up"
        "ALT,Down,focusdir,down"
        "SUPER,Left,viewtoleft,0"
        "SUPER,Right,viewtoright,0"
      ]
      ++ lib.concatMap (n: [
        "SUPER,${toString n},view,${toString n}"
        "SUPER+SHIFT,${toString n},tag,${toString n}"
      ]) (lib.range 1 9);

      exec_once = [
        "swaybg -i /etc/nixos/wallpapers/nixos.png -m fill"
        "swaync"
        "wl-clipboard"
        "grim"
      ];

    };

  };

  services.mangobar = {
    enable = true;
    settings = {
      modules-left = [
        "workspaces"
        "layout"
        "window"
      ];
      modules-right = [
        "custom/ssid"
        "custom/wifi"
        "cpu"
        "memory"
        "custom/disk"
        "battery"
        "clock#date"
        "clock#time"
      ];
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
      "custom/disk" = {
        exec = ''df -h / | awk 'NR==2{print $3"/"$2}' '';
        interval = 60;
        format = "󰋊 {}";
      };
      "clock#date" = {
        format = " {:L%b%d·%A}";
      };
      "clock#time" = {
        format = " {:L%I:%M %p}";
      };
    };
  };

  programs.swaylock = {
    enable = true;
    # Package choice: pkgs.swaylock or pkgs.swaylock-effects (for blur/fade)
    package = pkgs.swaylock;

    settings = {
      # Visual layout
      # color = "000000";             # Solid black background
      # image = "/path/to/wall.png"; # Or use a wallpaper image instead
      image = "/home/ruahman/Pictures/wallhaven-p9pd23_1920x1080.png";
      scaling = "fill";

      # Indicator options
      indicator = true;
      indicator-radius = 100;
      indicator-thickness = 7;

      # Color themes for the ring (Hex codes without '#')
      ring-color = "ffffff";
      key-hl-color = "8839ef"; # Highlight color when typing
      line-color = "00000000"; # Invisible inner line
      inside-color = "00000088"; # Semi-transparent inside circle

      # Behavior
      show-failed-attempts = true;
      ignore-empty-password = true;
    };
  };

  services.swayidle = {
    enable = true;

    # Target MangoWM's graphical session
    # systemdTargets = [ "mango-session.target" ];
    # systemdTargets = [ "graphical-session.target" ];

    # Extra arguments (e.g., -w to wait for command completion)
    # extraArgs = [ "-w" ];

    timeouts = [
      {
        timeout = 300; # 5 minutes
        # Lock the screen
        command = "${pkgs.swaylock}/bin/swaylock -fF";
      }
      # {
      #   timeout = 600; # 10 minutes
      #   # Turn off display using wlr-randr (or your preferred monitor tool)
      #   command = "${pkgs.wlr-randr}/bin/wlr-randr --output HEADLESS-1 --off";
      #   resumeCommand = "${pkgs.wlr-randr}/bin/wlr-randr --output HEADLESS-1 --on";
      # }
    ];

    events = {
      before-sleep = "${pkgs.swaylock}/bin/swaylock -fF";
      lock = "${pkgs.swaylock}/bin/swaylock -fF";
    };
  };
}
