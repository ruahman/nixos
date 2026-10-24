
{ inputs, pkgs, ... }:

{

  # setup flakes
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
  };

  # import hardware configuration
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  # mound nvme
  fileSystems."/mnt/nvme" = {
      device = "/dev/nvme0n1p1";
      fsType = "ext4";
      options = [ "nofail" ];
    };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

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
      nerd-fonts.caskaydia-cove
      nerd-fonts.caskaydia-mono
      nerd-fonts.jetbrains-mono 
      nerd-fonts.terminess-ttf 
      nerd-fonts.im-writing
      nerd-fonts.code-new-roman
    ];
  };

  # set the Display Manger
  # services.displayManager.sddm = {
  #    enable = true;
  #    #wayland.enable = true;
  # };
  # Enable greetd display manager daemon
  # services.greetd = {
  #   enable = true;
  #   settings = {
  #     default_session = {
  #       # tuigreet is used as the frontend greeter interface
  #       # --time displays the current time on the screen
  #       # --remember remembers the last successfully logged-in user
  #       # --cmd specifies the command to execute after login
  #       command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd mango";
  #       user = "greeter";
  #     };
  #   };
  # };
  # services.greetd = {
  #     enable = true;
  #     settings = {
  #       initial_session = {
  #         command = "mango";
  #         user = "ruahman"; # auto-login on first start, no password required
  #       };
  #       default_session = {
  #         command = "${pkgs.greetd-tuigreet}/bin/tuigreet --time --remember --cmd mango";
  #         # command = "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd mango";
  #         user = "greeter";
  #       };
  #     };
  #   };
  
  # enable xfce
  # services.xserver.enable = true; # enable the x11 window system
  # services.xserver.desktopManager.xfce.enable = true;
  # enable gnome
  # services.desktopManager.gnome.enable = true;
  # enable mongowm
  programs.mango.enable = true;

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd mango";
        user = "greeter";
      };
    };
  };

  # Configure keymap in X11
  # to get it to run:
  # gsettings reset org.gnome.desktop.input-sources xkb-options
  # gsettings reset org.gnome.desktop.input-sources sources
  services.xserver.xkb = {
    layout = "us";
    variant = "altgr-intl";
    options = "caps:ctrl_modifier,compose:lalt";
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
    #extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd" "podman" "incus-admin" "vmware"];
    extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd" "podman" "incus-admin"];
    packages = with pkgs; [
    ];
    shell = pkgs.nushell;
    #shell = pkgs.bash;
  };
  
  # Virtualization: KVM/QEMU via libvirt
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;               # emulated TPM 2.0 — required for Windows 11
    };
  };

  # virtualisation.vmware = {
  #   host.enable = true;
  # };

  # virtualisation.virtualbox = {
  #   host = {
  #     enable = true;
  #     enableExtensionPack = true;
  #   };
  # };

  # Let your user access USB devices and create VMs
  users.extraGroups.vboxusers.members = [ "ruahman" ];


  virtualisation.docker = {
    enable = true;
    #autoPrune.enable = true;   # optional: periodically removes unused images/containers
  };

  virtualisation.podman = {
    enable = true;
  };

  virtualisation.incus = {
    enable = true;
    ui.enable = true;
  };

  # Recommended: Incus's bridge networking works best with nftables
  networking.nftables.enable = true;

  # Let containers/VMs reach the host and the internet through the bridge
  networking.firewall.trustedInterfaces = [ "incusbr0" ];

  # allow dynamic link
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    libxkbcommon
    libGL
    fontconfig
    freetype
    wayland
    libx11
    libxcb
    libxcursor
    libxi
    libxrandr
    vulkan-loader
    libglvnd
    dbus
  ];

  # virt-manager GUI
  programs.virt-manager.enable = true;

  # USB passthrough / redirection from the SPICE console
  virtualisation.spiceUSBRedirection.enable = true;

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
    adwaita-icon-theme

    nano
    vim
    neovim
    git
    github-cli # provide authentication for git
    lazygit

    hplipWithPlugin  # HPLIP with proprietary plugins
    sane-backends    # For scanning
    xsane   # Optional GUI scanner tool

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
    "xdg/nvim/init.lua".text = ''
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.tabstop = 4
      vim.opt.shiftwidth = 4
      vim.opt.expandtab = true
    
      vim.g.mapleader = " "
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
