# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, pkgs, ... }:

{

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      #./fluent-bit.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Puerto_Rico";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_PR.UTF-8";
    LC_IDENTIFICATION = "es_PR.UTF-8";
    LC_MEASUREMENT = "es_PR.UTF-8";
    LC_MONETARY = "es_PR.UTF-8";
    LC_NAME = "es_PR.UTF-8";
    LC_NUMERIC = "es_PR.UTF-8";
    LC_PAPER = "es_PR.UTF-8";
    LC_TELEPHONE = "es_PR.UTF-8";
    LC_TIME = "es_PR.UTF-8";
  };

  # setup fonts
  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [ 
      font-awesome
      nerd-fonts.fira-code 
      nerd-fonts.fira-mono
      nerd-fonts.hack
      nerd-fonts.hasklug
      nerd-fonts.caskaydia-cove
      nerd-fonts.caskaydia-mono
      nerd-fonts.jetbrains-mono 
      nerd-fonts.symbols-only
      nerd-fonts.terminess-ttf 
      nerd-fonts.im-writing
    ];
  };
  
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  # to get it to run:
  # gsettings reset org.gnome.desktop.input-sources xkb-options
  # gsettings reset org.gnome.desktop.input-sources sources
  services.xserver.xkb = {
    layout = "us";
    variant = "";
    options = "caps:ctrl_modifier";
  };

  # enable console to use xkb settings
  console.useXkbConfig = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Install HPLIP with plugin support
  services.printing.drivers = [ pkgs.hplipWithPlugin ];

  # Optionally, enable Avahi for network printer discovery
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true; # For IPv4 name resolution
  services.avahi.openFirewall = true; # Open firewall for printer discovery

  # Ensure USB printing works (optional, for USB connection)
  hardware.sane.enable = true; # Enables scanning support
  #hardware.usb.enahhle = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;


  # nginx
  #services.nginx = {
  #  enable = true;                      # Enable Nginx
  #  virtualHosts.localhost = {
  #    listen = [ { addr = "127.0.0.1"; port = 80; } ];  # Listen on localhost:80
  #    #root = "/var/www/localhost";      # Directory to serve files from
  #    locations."/" = {
  #      extraConfig = ''
  #        default_type text/plain;  # Set the Content-Type to text/plain
  #        return 200 'Hello, world!, nginx';
  #      '';
  #    };
  #  };
  #};

  # caddy
  #services.caddy = {
  #  enable = true;
  #  virtualHosts.localhost.extraConfig = ''
  #    respond "Hello, world!, caddy"
  #  '';
  #};

  # couchdb
  #services.couchdb = {
  #  enable = true;                # Enable the CouchDB service
  #  adminUser = "admin";      # Set the admin username
  #  adminPass = "password";   # Set the admin password
  #  bindAddress = "0.0.0.0";      # Bind address (default is localhost)
  #};

  # postgres
  #services.postgresql = {
  #  enable = true;
  #  ensureDatabases = [ "mydatabase" ];
  #  authentication = pkgs.lib.mkOverride 10 ''
  #    #type database  DBuser  auth-method
  #    local all       all     trust
  #  '';
  #};

  # pgadmin
  #services.pgadmin = {
  #  enable = true;
  #  port = 5050; # Default port for pgAdmin
  #  initialEmail = "ruahman@gmail.com"; # Initial admin email
  #  initialPasswordFile = "/etc/pgadmin-password"; # File containing the initial password
  #};

  # redis
  #services.redis.servers."" = {
  #   enable = true;
  #   settings = {
  #     port = 6379;
  #   };
  #};

  # fluent-bit
  #services.fluent-bit.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ruahman = {
    isNormalUser = true;
    description = "ruahman";
    extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd" "podman" ];
    packages = with pkgs; [
    #  thunderbird
    ];
    #shell = pkgs.nushell;
    #shell = pkgs.bash;
  };
 
  # virt-manager 
  users.groups.libvirtd.members = ["ruahman"];

  # setup docker
  #virtualisation.docker.enable = true;

  # setup virtualisation
  #virtualisation = {
  #  containers.enable = true;
  #  #docker.enable = true;
  #  podman = {
  #    enable = true;
  #    dockerCompat = true;  # Optional, creates `docker` alias for `podman`
  #    defaultNetwork.settings.dns_enabled = true;  # For containers to talk to each other
  #  };
  #};

  # virt-manager
  #virtualisation.libvirtd.enable = true;
  
  # virt-manager
  #virtualisation.spiceUSBRedirection.enable = true;



  # run these containers at startup
  #virtualisation.oci-containers.containers = {
  #  "activemq-artemis" = {
  #    image = "docker.io/apache/activemq-artemis:latest-alpine";
  #    autoStart = true;
  #    ports = [ "0.0.0.0:8161:8161" "0.0.0.0:61613:61613" "0.0.0.0:61616:61616" ];
  #  };
  #  #"jaeger" = {
  #  #  image = "docker.io/jaegertracing/jaeger:2.2.0";
  #  #  autoStart = true;
  #  #  ports = [ "16686:16686" "4317:4317" "4318:4318" "5778:5778" "9411:9411" ];
  #  #};
  #  "jaeger" = {
  #    image = "docker.io/jaegertracing/all-in-one:1.47";
  #    autoStart = true;
  #    environment = {
  #      COLLECTOR_OTLP_ENABLED = "true";
  #      COLLECTOR_ZIPKIN_HTTP_PORT = "9411";
  #    };
  #    ports = [ 
  #      "6831:6831/udp"  # Jaeger compact Thrift protocol (UDP)
  #      "6832:6832/udp"  # Jaeger binary Thrift protocol (UDP)
  #      "5778:5778"      # Jaeger agent HTTP management port
  #      "16686:16686"    # Jaeger query UI port
  #      "4317:4317"      # Jaeger gRPC HTTP collector port
  #      "4318:4318"      # Jaeger gRPC HTTP collector port (encrypted)
  #      "14250:14250"    # Jaeger gRPC tracing port
  #      "14268:14268"    # Jaeger gRPC HTTP internal service communication port
  #      "14269:14269"    # Jaeger gRPC HTTP internal service communication port (encrypted) 
  #      "9411:9411"      # Zipkin collector port
  #    ];
  #  };
  #  #"zipkin" = {
  #  #  image = "docker.io/openzipkin/zipkin";
  #  #  autoStart = true;
  #  #  ports = [ "9411:9411" ];
  #  #};
  # "esplora" = {
  #   image = "docker.io/blockstream/esplora";
  #   autoStart = true;
  #   #volumes = [
  #   #  "/var/lib/bitcoin-regtest:/data"
  #   #];
  #   ports = [
  #     "50001:50001"
  #     "8094:80" 
  #   ];
  #   cmd = [ "bash" "-c" "/srv/explorer/run.sh bitcoin-regtest explorer" ];
  # };
  #};

  # setup kvm
  #boot.kernelModules = [ "kvm-amd" ]; 

  # virt-manager
  #programs.virt-manager.enable = true;

  # Install firefox.
  programs.firefox.enable = true;

  programs.hyprland = {
    enable = true;
    # set the flake package
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # make sure to also set the portal package, so that they are in sync
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    hunspellDicts.es_PR
    xdg-utils
    nano
    vim
    #(vim.overrideAttrs (old: {
    #  postInstall = ''
    #    ${old.postInstall or ""}
    #    wrapProgram $out/bin/vim --add-flags "-u /etc/vimrc"
    #  '';
    #  buildInputs = (old.buildInputs or []) ++ [ makeWrapper ];
    #}))
    xclip  # for sharing clipboard in terminal 
    pavucontrol # volume control
    blueman # bluetooth control
    git # source control
    gnupg
    #kitty  # kitty terminal
    #ghostty  # ghostty terminal
    hplipWithPlugin  # HPLIP with proprietary plugins
    sane-backends    # For scanning
    xsane   # Optional GUI scanner tool
    # Virutaliztion 
    #virt-manager
    #docker
    #docker-compose
    #podman
    #podman-compose
    #qemu
    #incus  # LXC/LXD
    #colima # container runtime manager
    gcc
    gnumake 
    cmake 
    binutils 
    glibc.dev 
    pkg-config
    gnome-control-center  # GNOME Settings app
    gnome-tweaks          # Optional: for advanced settings
    waybar # bar for hyprland
    wofi # search for hyprland
    hyprshot # screen shot for hyperland
    hyprpaper # wallpaper for hyperland
    waypaper # wallpaper selector
    hyprpicker # color picker for hyperland
    wl-clipboard # clipboard for hyperland
    nwg-look # GTK-setting editor
    catppuccin-gtk
    # network manager
    #networkmanagerapplet
    swaynotificationcenter # notifications
    libnotify # notification lib
    hyprlock # screenlock
    hypridle # idle 
  ];


  # desktop portals, enables screen share, etc???
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
 
  # in case of nvidia 
  environment.sessionVariables = {
    # disable hardware cursors, on some systems the cursor becomes invisable without it
    WLR_NO_HARDWARE_CURSORS = "1";
    # tell electron apps to use wayland
    NIXOS_OZONE_WL = "1";
  };

  environment.etc = {
    "gitconfig" = {
      target = ".gitconfig";
      text = ''
        [user]
          name = Diego R Vila
          email = dego_vila@yahoo.com
        [pull]
          rebase = true
        [init]
          defaultBranch = main
        [credential]
          helper = store
        [core]
          editor = nano
        [safe]
          directory = /etc/nixos
      '';
    };
    #"pgadmin-password" = {
    #  target = "pgadmin-password";
    #  text = "password";
    #};
    "vimrc".text = ''
      set number          " Show line numbers
      set relativenumber  " Relative line numbers
      set tabstop=4       " 4 spaces for tabs
      set shiftwidth=4    " Indentation width
      set expandtab       " Use spaces instead of tabs
      syntax on           " Enable syntax highlighting
 
      " Set leader to space
      let mapleader = " " 

      " xclip integration (if xclip is installed)
      noremap <Leader>y :w !xclip -selection clipboard<CR><CR>
      noremap <Leader>p :r !xclip -o -selection clipboard<CR>
    '';
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
