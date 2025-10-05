{ config, pkgs, ... }:

{
  home.username = "anhnt";
  home.homeDirectory = "/home/anhnt";
  home.stateVersion = "25.05";
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
  ];
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
    settings = {
      keybind = [
        "super+c=copy_to_clipboard"
        "super+v=paste_from_clipboard"
        "super+shift+c=copy_to_clipboard"
        "super+shift+v=paste_from_clipboard"
      ];
    };
  };

  programs.git = {
    enable = true;
    userName = "anhnt";
    userEmail = "tuananh131001@gmail.com";
  };
  programs.tmux = {
    enable = true;
  };

}
