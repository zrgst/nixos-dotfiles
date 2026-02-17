{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # --- BOOT & KERNEL --- #
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_zen; # Gaming-optimalisert kjerne
  boot.supportedFilesystems = [ "ntfs" ];
  boot.kernel.sysctl = {
    "vm.max_map_count" = 16777216; 
    "fs.file-max" = 524288;
  };

  # --- NVIDIA SPESIFIKT --- #
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    open = true; # Sett til true hvis du har Turing eller nyere (RTX 20-serie+)
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    prime.sync.enable = false;
    prime.offload.enable = false;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # LAGRING #
  fileSystems."/mnt/lagring" = {
    device = "/dev/disk/by-label/lagring";
    fsType = "ext4";
    options = [
      "nofail" # Forhindrer ikke boot
      "x-systemd.automount" # Monter disken når mappen åpnes
    ];
  };

  # --- NETTVERK & SSH --- #
  networking.hostName = "desktop-zrgst";
  networking.networkmanager.enable = true;
  services.tailscale.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false; # Sikrere med nøkler
      PermitRootLogin = "no";
    };
  };

  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "tailscale0" ];
    allowedTCPPorts = [ 22 ];
  };

  # --- FONT --- #
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # --- DISPLAY MANAGER (tuigreet) --- #
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd start-hyprland";
        user = "greeter";
      };
    };
  };

  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal";
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };

  # --- HYPRLAND PÅ NVIDIA MILJØVARIABLER --- #
  programs.hyprland.enable = true;
  environment.sessionVariables = {
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    LIBVA_DRIVER_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1"; # Viktig: Fjerner usynlig mus-problem
    NIXOS_OZONE_WL = "1"; # For Chrome/Electron/Discord
  };

  # --- BRUKER --- #
  users.users.zrgst = {
    isNormalUser = true;
    description = "zrgst";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" ];
    # Lim inn din offentlige nøkkel fra laptopen her:
    openssh.authorizedKeys.keys = [ 
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEOgGMOasuqiAsVZ8II7YWmU4dPIb1emw5jozj6mzGtw nixos-zrgst" 
    ];
  };

  # --- SYSTEM-PAKKER --- #
  environment.systemPackages = (with pkgs; [
    # Pakker fra "pkgs" her:
    vim
    wget
    git
    nh
    pavucontrol
    nvtopPackages.nvidia # GPU-overvåking
  ]) ++ [
    # Pakker som ikke er i "pkgs" her:
    inputs.nix-citizen.packages.${pkgs.system}.star-citizen
    inputs.nix-citizen.packages.${pkgs.system}.lug-helper
  ];

  # Aktiver udisks2 (nødvendig for å oppdage og mounte disker)
  services.udisks2.enable = true;

  # Aktiver gvfs (nødvendig for at Thunar skal kunne kommunisere med disker)
  services.gvfs.enable = true;

  # Valgfritt: Aktiver devmon (hvis du vil at ting skal mountes automatisk uten at du klikker)
  services.devmon.enable = true;

  # UDEV #
  services.udev.packages = [ pkgs.vial ];
  
  hardware.keyboard.qmk.enable = true;

  # --- DIVERSE --- #
  time.timeZone = "Europe/Oslo";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "no";
  swapDevices = [ { device = "/swapfile"; size = 32768; } ];

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Gaming tweaks
  programs.steam.enable = true;
  programs.gamemode.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.11";
}
