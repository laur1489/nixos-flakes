# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Bucharest";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  services.blueman.enable = true;
  # Enable the X11 windowing system.
      services.xserver = {
  enable = true;
  displayManager.sessionCommands = ''
    ${pkgs.xorg.xset}/bin/xset s off
    ${pkgs.xorg.xset}/bin/xset -dpms
    ${pkgs.xorg.xset}/bin/xset s noblank
    ${pkgs.xorg.xset}/bin/xset r rate 200 40
    ${pkgs.feh}/bin/feh --bg-fill /home/laur/Pictures/Wallpapers/castle.jpg &
    ${pkgs.xorg.xsetroot}/bin/xsetroot -cursor_name left_ptr
  '';
  windowManager.dwm.enable = true;
};  


  services.xserver.desktopManager.session = [
     {
      name = "custom-xsession";
      bgSupport = true;
      start = "exec $HOME/.xsession";
     }
   ];

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";
  services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  services.printing = {
  enable = true;
  drivers = [ pkgs.hplipWithPlugin ];
};

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  services.pipewire = {
     enable = true;
     alsa.enable = true;
     alsa.support32Bit = true;
     pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  services.minidlna = {
  enable = true;
  openFirewall = true;
  settings = {
    friendly_name = "NixOs";
    media_dir = [ "V,/mnt/storage/Videos" ];
    album_art_names = "Cover.jpg/cover.jpg/AlbumArtSmall.jpg/albumartsmall.jpg/AlbumArt.jpg/albumart.jpg/Album.jpg/album.jpg/Folder.jpg/folder.jpg/Thumb.jpg/thumb.jpg";
    # Change these to strings:
    enable_tivo = "yes";
    strict_dlna = "no";
    enable_subtitles = "yes"; 
  };
};

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.laur = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
    packages = with pkgs; [
      tree
    ];
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs.firefox.enable = true;
  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    autosuggestions.enable = true;
};


  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    neovim
    firefox
    fastfetch
    alacritty
    st
    kdePackages.dolphin
    dmenu
    kdePackages.qtsvg
    kdePackages.breeze-icons
    kdePackages.kio-extras
    kdePackages.ffmpegthumbs
    rofi
    xclip
    lf
    maim
    tmux
    pfetch
    zsh-syntax-highlighting
    zsh-autosuggestions
    dunst
    blueman
    localsend
    steam
    discord
    discord-ptb
    feh
    bibata-cursors
    prismlauncher
    nsxiv
    kew
    git
    gcc
    gnumake
    tealdeer
    bat
    mpv
    blender
    ani-cli
    curl
    aria2
    python314Packages.yt-dlp
    ffmpeg
    fzf
    minidlna
    qbittorrent
    exfatprogs
    opencode
    jdk25
    jdk
    chromium
    libreoffice
    btop
    kdePackages.ark
    obs-studio
    anydesk
    pavucontrol
    qpwgraph
    protonup-qt
    pkgs.fetch
  ];

  environment.sessionVariables = {
    PATH = [
      "$HOME/.local/bin"
    ];
   };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  services.udisks2.enable = true;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall = {
  enable = true;
  allowedTCPPorts = [ 53317 8200 ];
  allowedUDPPorts = [ 53317 1900 ];
};
 
  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?

nixpkgs.config.allowUnfree = true;

services.xserver.videoDrivers = [ "nvidia" ];

xdg.mime.enable = true;

hardware.nvidia = {
  modesetting.enable = true;
  powerManagement.enable = false;
  powerManagement.finegrained = false;
  open = true;
  nvidiaSettings = true;
  package = config.boot.kernelPackages.nvidiaPackages.stable;
  prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };
};

hardware.graphics = {
    enable = true;
    enable32Bit = true; # Fixes the 32-bit Steam / Wine driver crashes
  };

environment.sessionVariables = {
  # Forces applications to use the NVIDIA GPU for OpenGL
  __NV_PRIME_RENDER_OFFLOAD = "1";
  __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  __VK_LAYER_NV_optimus = "NVIDIA_only";
};

fonts.packages = with pkgs; [
  jetbrains-mono
  nerd-fonts.jetbrains-mono
];

fileSystems."/mnt/storage" = {
  device = "/dev/disk/by-uuid/48c6239c-0f39-4d31-a562-db4eb1b72bf8";
  fsType = "ext4";
  options = [ "defaults" "nofail" ];
};

}

