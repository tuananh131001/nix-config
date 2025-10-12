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
  home.stateVersion = "25.05";
  xdg.enable = true;
  
  xdg.configFile = {
    "i3/config".text = builtins.readFile ./i3;
  };

  programs.mise = {
    enable = true;
    enableFishIntegration = true; # or enableBashIntegration / enableFishIntegration
    settings = {
      # global default versions
      nodejs = "lts";
      go = "latest";
      ruby = "latest";
    };
  };
  programs.fish = {
    enable = true;
  };
  home.packages = [
    pkgs.wget
    pkgs.neovim
    pkgs.nodejs
    pkgs.gh
    pkgs.python3
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
    pkgs.zlib
    pkgs.claude-code
    pkgs.libsecret
    pkgs.gcr
    pkgs.bitwarden-desktop
  ]
  ++ lib.optionals (currentSystemName == "pc-intel") [
    pkgs.discord-ptb
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
    userName = "anhnt";
    userEmail = "tuananh131001@gmail.com";
  };
  # Make cursor not tiny on HiDPI screens
  home.pointerCursor = lib.mkIf (isLinux && !isWSL) {
    name = "Vanilla-DMZ";
    package = pkgs.vanilla-dmz;
    size = 128;
    x11.enable = true;
  };
}
