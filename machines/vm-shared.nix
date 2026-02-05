# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  currentSystemName,
  ...
}:
{
  # Be careful updating this.
  boot.kernelPackages = pkgs.linuxPackages_6_18;
  users.groups.keyd = {};

  imports = [
    # Include the results of the hardware scan.
    ../modules/specialization/plasma.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 5;

  networking.hostName = "nixos-anhnt"; # Define your hostname.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Asia/Bangkok";
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.substituters = [ "https://claude-code.cachix.org" ];
  nix.settings.trusted-public-keys = [ "claude-code.cachix.org-1:YeXf2aNu7UTX8Vwrze0za1WEDS+4DuI2kVeWEE4fsRk=" ];

  # Enable nix-ld for running dynamically linked binaries (uvx, chroma-mcp, etc.)
  programs.nix-ld.enable = true;

  programs.adb.enable = true;
  nixpkgs.config.android_sdk.accept_license = true;

  programs.tmux.enable = true; # home-manager created ~/.config/tmux which causes my chezmoi config broken
  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
    nativeMessagingHosts.packages = [ pkgs.firefoxpwa ];
  };


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages =
    with pkgs;
    [
      cachix
      gnumake
      killall
      xclip
      kdePackages.dolphin
      keyd
      firefoxpwa

      # For hypervisors that support auto-resizing, this script forces it.
      # I've noticed not everyone listens to the udev events so this is a hack.
      (writeShellScriptBin "xrandr-auto" ''
        xrandr --output Virtual-1 --auto
      '')
      # When using external 27 inch display
      (writeShellScriptBin "xrandr-auto-big" ''
        xrandr --output Virtual-1 --auto --scale 1.5
      '')
    ]
    ++ lib.optionals (currentSystemName == "vm-aarch64") [
      # This is needed for the vmware user tools clipboard to work.
      # You can test if you don't need this by deleting this and seeing
      # if the clipboard sill works.
      gtkmm3
    ];

  services.keyd = {
    enable = true;
    keyboards = {
      # The name is just the name of the configuration file, it does not really matter
      default = {
        extraConfig = builtins.readFile ./keyd;
      };
    };
  };
  systemd.services.keyd.serviceConfig.CapabilityBoundingSet = [
  "CAP_SETGID"                                               
];

  # Virtualization settings
  virtualisation.docker.enable = true;

  # Vietnamese babie
  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5.addons = with pkgs; [
      qt6Packages.fcitx5-unikey
      fcitx5-gtk
    ];
  };

  # Desktop portals (GTK for i3, KDE for Plasma)
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.kdePackages.xdg-desktop-portal-kde
    ];
    config.common.default = "*";
  };

  # If you want to use multiple desktop
  # services.xserver =  lib.mkIf (config.specialisation != {}) {
  #   enable = true;
  #   xkb.layout = "us";
  #   xkb.model = "apple";
  #   xkb.variant = "basic"; # Fix dead key on Keychon K8 Max
  #
  #   displayManager = {
  #     lightdm.enable = true;
  #     defaultSession = "none+i3";
  #
  #     # AARCH64: For now, on Apple Silicon, we must manually set the
  #     # display resolution. This is a known issue with VMware Fusion.
  #     sessionCommands = ''
  #       ${pkgs.xorg.xset}/bin/xset r rate 500 20
  #     '';
  #   };
  #
  #   windowManager = {
  #     i3.enable = true;
  #   };
  # };

  # Plasma 6 By Default
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Auto-login for headless/remote access (Sunshine needs a graphical session)
  services.displayManager.autoLogin = {
    enable = true;
    user = "anhnt";
  };

  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true; 
    package = pkgs.sunshine.override {
      cudaSupport = true;
      cudaPackages = pkgs.cudaPackages; # <-- I needed this bit
    };
  };

  # SSH for LAN access
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "no";
    };
  };

  services.tailscale.enable = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
  };

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
    nerd-fonts.noto
    nerd-fonts.symbols-only
  ];

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?
}
