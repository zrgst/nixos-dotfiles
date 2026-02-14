{ config, pkgs, inputs, ... }:

let
  flake-root = inputs.self;
in
{
  home.username = "zrgst";
  home.homeDirectory = "/home/zrgst";
  home.stateVersion = "25.11";

  # --- SSH OPPSETT --- #
  # Dette lar deg styre den stasjonære med "ssh stasjonar"
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "desktop" = {
        hostname = "100.125.247.97";
        user = "zrgst";
      };
      "*" = {
        setEnv = { TERM = "xterm-256color"; };
      };
    };
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo I use nixos, btw";
      ll = "ls -l";
      la = "ls -la";
      rebuild = "sudo nixos-rebuild switch --flake ${flake-root}#laptop";
    };
    # Denne linjen henter innholdet fra din fil og legger det i den genererte .bashrc
    bashrcExtra = builtins.readFile "${flake-root}/terminal/.bashrc";
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Zrgst";
        email = "zrgst@protonmail.com";
      };
      alias = {
        st = "status";
        co = "checkout";
        cm = "commit";
      };
    };
  };

  home.packages = with pkgs; [
    # --- TOOLS --- #
    firefox
    chromium
    alacritty
    fzf
    neovim
    ripgrep
    nil
    nixpkgs-fmt
    blueman
    blueberry
    networkmanagerapplet
    thunar # FIKSET: xfce.thunar -> thunar
    thunar-volman
    qbittorrent
    flatpak
    carburetor
    lazygit
    
    # --- CODING TOOLS --- #
    nodejs
    gcc
    
    # --- GAMING --- #
    mangohud
    heroic
    lutris
    gamemode
    wineWowPackages.stable # Bedre alternativ for wine i nyere Nixpkgs
    winetricks
    protonup-rs
    vesktop
    dotnetCorePackages.runtime_9_0-bin # For SPT server
    
    # --- MEDIA --- #
    vlc
    obs-studio
    qimgv
    
    # --- OFFICE --- #
    pdfstudioviewer
    libreoffice-qt
    
    # --- HYPRLAND ESSENTIALS --- #
    polkit_gnome
    swayosd
    mako
    libnotify
    wl-clipboard
    fuzzel
    btop
    rofi
    sunsetr
    hyprlock
    cmus
    swappy
    hyprpicker
    waybar
    grim
    slurp
    grimblast
    cliphist
    swww
    adwaita-qt6
    signal-desktop
    tmux # La til denne siden vi snakket om den!
    rsync # La til denne for enkel fildeling
  ];

  # Mousepeker
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
  };

  # GTK settings/theming
  gtk = {
    enable = true;
    theme = {
      name = "Tokyonight-Dark";
      package = pkgs.tokyonight-gtk-theme;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 11;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  # QT apps
  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };

  # DCONF
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  # Path
  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  # --- XDG CONFIG & DOTFILES --- #
  # Her kobler vi mappene fra din flake-mappe til ~/.config
  xdg.configFile = {
    "alacritty".source = "${flake-root}/config/alacritty";
    "qtile".source = "${flake-root}/config/qtile";
    "rofi".source = "${flake-root}/config/rofi";
    "nvim".source = "${flake-root}/config/nvim";
    "hypr".source = "${flake-root}/config/hypr";
    "waybar".source = "${flake-root}/config/waybar";
    "mako".source = "${flake-root}/config/mako";
    "fuzzel".source = "${flake-root}/config/fuzzel";
  };

  # Scripts og Shell configs
  home.file = {
    ".local/bin".source = "${flake-root}/local/bin";
  };
}
