{ config, pkgs, ... }:

{
  imports = [
    # This is the key hardware-specific import for your laptop.
    # It handles NVIDIA drivers, audio, keyboard, and power management.
    "${builtins.fetchGit { url = "https://github.com/NixOS/nixos-hardware.git"; }}/asus/zephyrus/g603h"
    ./hardware-configuration.nix
  ];

  # Bootloader (systemd-boot is great for this hardware)
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 0; # Set to 3 or 5 if you want to see the boot menu
    };
    # Plymouth (graphical boot splash)
    plymouth.enable = true;
    # Clean boot logs
    initrd.verbose = false;
    consoleLogLevel = 0;
    kernelParams = [
      "quiet"
      "splash"
      "loglevel=3"
      "rd.systemd.show_status=false"
    ];
  };

  # Memory Management
  zramSwap.enable = true;
  swapDevices = [{
    device = "/swapfile";
    size = 24 * 1024; # 24GB swap file
  }];

  # Networking (Keeping your custom Docker firewall rules)
  networking = {
    networkmanager.enable = true;
    hostName = "zephyrus-m16"; # You can customize this
    firewall = {
      extraCommands = ''
        iptables -N DOCKER-ISOLATION-STAGE-1
        iptables -N DOCKER-ISOLATION-STAGE-2
        iptables -A FORWARD -j DOCKER-ISOLATION-STAGE-1
        iptables -A DOCKER-ISOLATION-STAGE-1 -i docker0 ! -o docker0 -j DOCKER-ISOLATION-STAGE-2
        iptables -A DOCKER-ISOLATION-STAGE-2 -j DROP
      '';
      checkReversePath = false; # For Nekoray DNS
    };
  };
  
  # Set your time zone and locale
  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.UTF-8";

  # Sound and Hardware
  hardware = {
    pulseaudio.enable = false; # Managed by Pipewire
    # Enable Nvidia containers in Docker
    nvidia-container-toolkit.enable = true;
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  # Fonts (Keeping your Nerd Fonts selection)
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
    fira-code
  ];

  # User Account (Simplified for hbohlen)
  users = {
    defaultUserShell = pkgs.zsh;
    users.hbohlen = {
      isNormalUser = true;
      description = "Hayden Bohlen";
      extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd" ];
    };
  };

  # Programs
  programs = {
    zsh.enable = true;
    steam.enable = true;
    virt-manager.enable = true;
    git = {
      enable = true;
      lfs.enable = true;
    };
  };
  
  # Services
  services = {
    # Pipewire for audio
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # Enable printing and Bluetooth management
    printing.enable = true;
    blueman.enable = true;
    
    # Enable asusctl for ROG-specific controls (handled by nixos-hardware import)
    # services.asusctl.enable = true; is implicitly enabled.

    # GNOME Desktop Environment
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      # Keeping your custom GNOME settings for high-DPI display
      xkb = {
        layout = "us";
        options = "grp:win_space_toggle";
      };
    };
  };

  # Virtualization (Docker & KVM/QEMU)
  virtualisation = {
    libvirtd.enable = true;
    docker = {
      enable = true;
      storageDriver = "btrfs";
      # Your custom option to prevent Docker from modifying iptables
      extraOptions = "--iptables=false";
    };
  };

  # Allow unfree packages and unstable channel for specific packages
  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: {
      unstable = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz") {
        config.allowUnfree = true;
      };
    };
  };

  # System-wide packages
  environment.systemPackages = with pkgs; [
    # Your preferred tools
    git
    wget
    btop
    fastfetch
    gnome-tweaks
    
    # Add your extensive list of packages here...
    # For example:
    unstable.vscode
    alacritty
    firefox
  ];

  # Shell aliases from your previous config
  environment.shellAliases = {
    system-rebuild = "sudo nixos-rebuild switch --flake .#";
    system-update = "sudo nixos-rebuild switch --flake .# --upgrade";
    nvidia-run = "__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia";
  };
  
  # Enable experimental Nix features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # System state version
  system.stateVersion = "24.05"; # Or "24.11" if you are tracking unstable
}
