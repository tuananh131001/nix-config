{
  isWSL,
  inputs,
  currentSystemName,
  ...
}:

{
  config,
  lib,
  pkgs,
  ...
}:
let
  isLinux = pkgs.stdenv.isLinux;
in
{
  home.stateVersion = "25.11";
  imports = [
    inputs.zen-browser.homeModules.beta
    inputs.plasma-manager.homeModules.plasma-manager
    # or inputs.zen-browser.homeModules.twilight
    # or inputs.zen-browser.homeModules.twilight-official
  ];
  xdg.enable = true;
  
  xdg.configFile = {
    "i3/config".text = builtins.readFile ./i3;
    "rofi/config.rasi".text = builtins.readFile ./rofi;
  };

  programs.fish = {
    enable = true;
  };
  home.packages = [
    pkgs.wget
    pkgs.neovim
    pkgs.gh
    pkgs.gcc
    pkgs.fzf
    pkgs.ripgrep
    pkgs.fd
    pkgs.htop
    pkgs.nixfmt-rfc-style
    pkgs.sesh
    pkgs.gnumake
    pkgs.mise
    pkgs.chezmoi
    pkgs.firefox
    pkgs.brave
    pkgs.zlib
    pkgs.claude-code
    pkgs.libsecret
    pkgs.gcr
    pkgs.rofi
    pkgs.geist-font

    # dev
    pkgs.devenv
    pkgs.p7zip

    # Language
    pkgs.nodejs
    pkgs.python3
    pkgs.zig
    pkgs.ruby

    # Apps
    pkgs.remnote
    pkgs.bitwarden-desktop
    pkgs.legcord
    pkgs.vicinae
    (pkgs.callPackage ./ww-run-raise.nix { })
  ]
  ++ lib.optionals (currentSystemName == "pc-intel") [
    pkgs.discord-ptb
    pkgs.vesktop
    pkgs.alsa-utils
    pkgs.ethtool
  ];
  services.gnome-keyring = {
    enable = true;
    components = [ "secrets" ];
  };

  programs.starship = {
    enable = true;
  };
  programs.zen-browser.enable = true;

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };
  programs.ghostty = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "anhnt";
        email = "tuananh131001@gmail.com";
      };
    };
  };

  xresources.extraConfig = builtins.readFile ./Xresources;
  # Make cursor not tiny on HiDPI screens
  home.pointerCursor = lib.mkIf (isLinux && !isWSL) {
    name = "Vanilla-DMZ";
    package = pkgs.vanilla-dmz;
    size = 128;
    x11.enable = true;
  };

  # MacOS-like window switching
  programs.plasma = {
    enable = true;
    shortcuts.kwin = {
      "Walk Through Windows" = "Meta+Tab";
      "Edit.Copy" = "Meta+C";
      "Edit.Paste" = "Meta+V";
    };
    configFile = {
      kdeglobals = {
        Shortcuts = {
          Copy = "Meta+C";
          Cut = "Meta+X";
          Find = "Meta+F";
          Paste = "Meta+V";
          Redo = "Meta+Shift+Z";
          SelectAll = "Meta+A";
          Undo = "Meta+Z";
        };
      };
    };

    hotkeys.commands = {
      "browser" = {
        name = "Focus Firefox";
        key = "Alt+1";
        command = "ww -f firefox -c firefox";
      };
      "ghostty" = {
        name = "Focus Ghostty";
        key = "Alt+2";
        command = "ww -f com.mitchellh.ghostty -c ghostty";
      };
    };
  };

}
