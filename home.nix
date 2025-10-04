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
    pkgs.ghostty
    pkgs.nodejs
    pkgs.gh
    pkgs.python3
    pkgs.gcc
    pkgs.fzf
    pkgs.ripgrep
    pkgs.fd
    pkgs.htop
  ];

  programs.git = {
    enable = true;
    userName = "anhnt";
    userEmail = "tuananh131001@gmail.com";

  };
  programs.bash = {
  
  };


}
