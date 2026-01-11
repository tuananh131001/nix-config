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
 services.xserver = {
    videoDrivers = [ "nvidia" ];

    config = ''
      Section "Device"
          Identifier  "Intel Graphics"
          Driver      "intel"
          #Option      "AccelMethod"  "sna" # default
          #Option      "AccelMethod"  "uxa" # fallback
          Option      "TearFree"        "true"
          Option      "SwapbuffersWait" "true"
          BusID       "PCI:0:2:0"
          #Option      "DRI" "2"             # DRI3 is now default
      EndSection

      Section "Device"
          Identifier "nvidia"
          Driver "nvidia"
          BusID "PCI:1:0:0"
          Option "AllowEmptyInitialConfiguration"
      EndSection
    '';
    screenSection = ''
      Option         "metamodes" "nvidia-auto-select +0+0 {ForceFullCompositionPipeline=On}"
      Option         "AllowIndirectGLXProtocol" "off"
      Option         "TripleBuffer" "on"
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
  hardware.nvidia-container-toolkit.enable = true;
  boot = {
    kernelParams =
      [ "acpi_rev_override" "mem_sleep_default=deep" "intel_iommu=igfx_off" "nvidia-drm.modeset=1" ];
  extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
  }; # fix nvidia tearing https://discourse.nixos.org/t/getting-nvidia-to-work-avoiding-screen-tearing/10422/7
  
  # boot.kernelParams = [ "snd-intel-dspcfg.dsp_driver=1" ];

  # Steam
  programs.steam.enable = true;

  # Syncthing
  services.syncthing = {
    enable = true;
    openDefaultPorts = true; # Open ports in the firewall for Syncthing
  };

  # FTP server for faster FolderSync transfers
  services.vsftpd = {
    enable = true;
    localUsers = true;
    writeEnable = true;
    localRoot = "/run/media/anhnt/WD4T-PHER01";
    extraConfig = ''
      pasv_enable=YES
      pasv_min_port=51000
      pasv_max_port=51999
    '';
  };

  # Open FTP ports (merges with existing firewall in vm-shared.nix)
  networking.firewall.allowedTCPPorts = [ 21 ];
  networking.firewall.allowedTCPPortRanges = [
    { from = 51000; to = 51999; }  # Passive FTP data ports
  ];

  # HDD power management - spin down external WD 4TB after 30 minutes idle
  # -B 127: APM level (less aggressive power saving)
  # -S 241: Spindown timeout (241 = 30 minutes)
  services.udev.extraRules = ''
    ACTION=="add", KERNEL=="sd[a-z]", ENV{ID_FS_UUID}=="42C8424BC8423D83", RUN+="${pkgs.hdparm}/bin/hdparm -B 127 -S 241 $env{DEVNAME}"
  '';
}
