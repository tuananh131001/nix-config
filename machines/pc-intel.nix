{ config, pkgs, lib, ... }:
{
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

  hardware.alsa.enablePersistence = true;
    # Nvidia
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = ["nvidia"];
  services.xserver = {
    # Set default screen resolution and refresh rate
    screenSection = ''
      Option "PreferredMode" "1920x1080_100.00"
    '';
  };
  hardware.nvidia = {
    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    open = true;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  boot.kernelParams = [ "snd-intel-dspcfg.dsp_driver=1" ];

  # Steam
  programs.steam.enable = true;

  # Syncthing
  services.syncthing = {
    enable = true;
    openDefaultPorts = true; # Open ports in the firewall for Syncthing
  };
}
