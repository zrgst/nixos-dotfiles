{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # --- BOOT & KERNEL --- #
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # --- GRAFIKK --- #
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # --- NETTVERK --- #
  networking.hostName = "nixos-zrgst";
  networking.networkmanager.enable = true;
  services.tailscale.enable = true;
  
  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "tailscale0" ];
    allowedTCPPorts = [ 22 ];
  };

  # --- LOKALISERING --- #
  time.timeZone = "Europe/Oslo";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "no";

  # --- DISPLAY MANAGER (tuigreet) --- #
  # Dette erstatter 'ly' og 'sddm'
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        # --time viser klokka, --remember husker sist brukte brukernavn
	command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd start-hyprland";
        # --cmd spesifiserer hva som skal startes etter login
       
        user = "greeter";
      };
    };
  };

  # Fix for at tuigreet skal se bra ut og ikke kræsje med boot-meldinger
  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal";
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };

  # X11 / Window Managers
  services.xserver = {
    enable = true;
    xkb.layout = "no";
    xkb.options = "eurosign:e,caps:escape";
    
    windowManager.qtile = {
      enable = true;
      extraPackages = python3Packages: with python3Packages; [ qtile-extras ];
    };
  };

  # Hyprland
  programs.hyprland.enable = true;

  # --- LYD --- #
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # --- BLUETOOTH --- #
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true; # Starter bluetooth automatisk ved oppstart
  services.blueman.enable = true;

  # --- HARDWARE SERVICES --- #
  services.libinput.enable = true;
  services.flatpak.enable = true;
  
  services.auto-cpufreq.enable = true;
  services.auto-cpufreq.settings = {
    battery = { governor = "powersave"; turbo = "auto"; };
    charger = { governor = "performance"; turbo = "auto"; };
  };

  # --- BRUKER --- #
  users.users.zrgst = {
    isNormalUser = true;
    description = "zrgst";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" ];
  };

  # --- SYSTEM-PAKKER --- #
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    nh
    pavucontrol
    pamixer
    vulkan-tools
    tuigreet # Selve grensesnittet
  ];

  # --- FONTS --- #
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
  ];

  # --- SSH & FJERNSTYRING --- #
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "no";
    };
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib
    zlib
    openssl
    curl
  ];

  programs.steam.enable = true;

  # --- NIX SETTINGS --- #
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  system.stateVersion = "25.11";
}
