{ config, pkgs, lib, ... }: {
  imports = [
    ./hardware/pc-intel.nix
    ./vm-shared.nix
  ];

    
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


    # Nvidia
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia.open = true;

  boot.kernelParams = [ "snd-intel-dspcfg.dsp_driver=1" ];

  # Steam
  programs.steam.enable = true;

}
