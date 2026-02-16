# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, pkgs, ... }:

{

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
  };

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
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
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  # to get it to run:
  # gsettings reset org.gnome.desktop.input-sources xkb-options
  # gsettings reset org.gnome.desktop.input-sources sources
  services.xserver.xkb = {
    layout = "us";
    variant = "";
    #options = "caps:ctrl_modifier,compose:lalt";
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

  # fixes blutooth headset problem
  services.pipewire.wireplumber.extraConfig."10-disable-bt-autoswitch" = {
    "wireplumber.settings" = {
      "bluetooth.autoswitch-to-headset-profile" = false;
    };
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ruahman = {
    isNormalUser = true;
    description = "ruahman";
    extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd" "podman" ];
    packages = with pkgs; [
    #  thunderbird
    ];
    #shell = pkgs.bash;
  };
 
  # virt-manager 
  users.groups.libvirtd.members = ["ruahman"];

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  #nixpkgs.config.allowUnsupportedSystem = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    nano
    vim
    git
    hplipWithPlugin  # HPLIP with proprietary plugins
    sane-backends    # For scanning
    xsane   # Optional GUI scanner tool

    # UI
    xdg-utils
    gnome-control-center  # GNOME Settings app
    gnome-tweaks          # Optional: for advanced settings
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
