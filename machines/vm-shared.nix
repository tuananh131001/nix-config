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
  boot.kernelPackages = pkgs.linuxPackages_6_17;

  imports = [
    # Include the results of the hardware scan.
    ../modules/specialization/plasma.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 7;

  networking.hostName = "nixos-anhnt"; # Define your hostname.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Asia/Bangkok";
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  programs.tmux.enable = true; # home-manager created ~/.config/tmux which causes my chezmoi config broken

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
    enable = false;
    keyboards = {
      # The name is just the name of the configuration file, it does not really matter
      default = {
        extraConfig = builtins.readFile ./keyd;
      };
    };
  };

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

  # I3
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
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
