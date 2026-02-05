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
  # unstable = import inputs.nixpkgs-unstable {
  #   system = pkgs.system;
  #   config.allowUnfree = true;
  # };
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
    "keyd/app.conf".text = builtins.readFile ./keyd_app;
    "fcitx5/config".text = builtins.readFile ./fcitx5;
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
    pkgs.brave
    pkgs.zlib
    inputs.claude-code.packages.${pkgs.system}.claude-code
    inputs.zccinfo.packages.${pkgs.system}.default
    pkgs.libsecret
    pkgs.gcr
    pkgs.geist-font
    pkgs.emote

    # dev
    pkgs.devenv
    pkgs.p7zip

    # Language
    pkgs.nodejs
    pkgs.bun
    pkgs.python3
    pkgs.zig
    pkgs.ruby

    # Apps
    pkgs.remnote
    pkgs.bitwarden-desktop
    pkgs.legcord
    pkgs.obsidian
    (pkgs.callPackage ./ww-run-raise.nix { })
  ]
  ++ lib.optionals (currentSystemName == "pc-intel") [
    pkgs.android-studio
    pkgs.discord-ptb
    pkgs.vesktop
    pkgs.alsa-utils
    pkgs.ethtool
  ];
  # programs.vicinae = {
  #   enable = true;
  # };
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
      "Walk Through Windows" = "Ctrl+Tab"; 
    };
    # configFile = {
    #   kdeglobals = {
    #     Shortcuts = {
    #       Copy = "Meta+C";
    #       Cut = "Meta+X";
    #       Find = "Meta+F";
    #       Paste = "Meta+V";
    #       Redo = "Meta+Shift+Z";
    #       SelectAll = "Meta+A";
    #       Undo = "Meta+Z";
    #     };
    #   };
    # };

    hotkeys.commands = {
      # "browser" = {
      #   name = "Focus Firefox";
      #   key = "Alt+1"; # Command + 1
      #   command = "ww -f firefox -c firefox";
      # };
      "browser" = {
        name = "Focus Zen Browser";
        key = "Alt+1"; # Command + 1
        command = "ww -f zen-beta -c zen";
      };
      "ghostty" = {
        name = "Focus Ghostty";
        key = "Alt+2"; # Command + 2
        command = "ww -f com.mitchellh.ghostty -c ghostty";
      };
      "emote" = {
        name = "Emoji Picker";
        key = "Meta+Ctrl+Space";
        command = "emote";
      };
    };
  };

  # Keyd app
  systemd.user.services.keyd-application-mapper = {
      Unit = {
          Description = "keyd application mapper";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
      };
      Install = {
          WantedBy = [ "graphical-session.target" ];
      };
      Service = {
          Type = "simple";
          ExecStart = "${pkgs.keyd}/bin/keyd-application-mapper";
          Restart = "on-failure";
          RestartSec = 3;
      };
  };

  # Fix Plasma taskbar icons after rebuild/GC
  # Converts absolute /nix/store paths to applications: protocol
  systemd.user.services.fix-plasma-taskbar-icons = {
      Unit = {
          Description = "Fix KDE Plasma task manager icons";
          After = [ "graphical-session.target" ];
      };
      Install = {
          WantedBy = [ "graphical-session.target" ];
      };
      Service = {
          Type = "oneshot";
          ExecStart = "${pkgs.writeShellScript "fix-plasma-icons" ''
            CONFIG="$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc"
            if [ -f "$CONFIG" ]; then
              ${pkgs.gnused}/bin/sed -i '/^launchers=/s|file:///[^,]*/\([^,/]*\)|applications:\1|g' "$CONFIG"
            fi
          ''}";
      };
  };

}
