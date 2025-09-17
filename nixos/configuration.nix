{ config, pkgs, ... }:

{
  imports = [
    # This is the key hardware-specific import for your laptop.
    # It handles NVIDIA drivers, audio, keyboard, and power management.
    "${builtins.fetchGit { url = "https://github.com/NixOS/nixos-hardware.git"; }}/asus/zephyrus/g603h"
  ];

  # Bootloader, Kernel, and Hardware Tweaks
  boot = {
    # Use the latest kernel for best support with supergfxctl
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    # Fix backlight control in hybrid graphics mode
    kernelParams = [
      "quiet"
      "splash"
      "i915.enable_dpcd_backlight=1"
      "nvidia.NVreg_EnableBacklightHandler=0"
      "nvidia.NVReg_RegistryDwords=EnableBrightnessControl=0"
    ];
  };
  
  # HiDPI console font for better readability in TTY
  console.font = "${pkgs.terminus_font}/share/consolefonts/ter-v32n.psf.gz";

  # Set your time zone and locale
  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.UTF-8";

  # User Account
  users.users.hbohlen = {
    isNormalUser = true;
    description = "Hayden";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" ]; # "wheel" allows sudo
  };

  # Networking
  networking.networkmanager.enable = true;
  networking.hostName = "zephyrus-m16";

  # Allow unfree packages (for NVIDIA drivers)
  nixpkgs.config.allowUnfree = true;

  # Hardware-specific services and settings
  services = {
    # ASUS and Graphics Control Services
    asusd = {
      enable = true;
      enableUserService = true;
    };
    supergfxd.enable = true;

    # GNOME Desktop Environment
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
    
    # Fix for supergfxctl to detect the graphics card
    udev.extraHwdb = ''
      evdev:name:*:dmi:bvn*:bvr*:bd*:svnASUS*:pn*:*
       KEYBOARD_KEY_ff31007c=f20    # fixes mic mute button
    '';
  };
  systemd.services.supergfxd.path = [ pkgs.pciutils ];

  # NVIDIA Graphics Configuration
  hardware.nvidia = {
    # Use the open-source kernel modules, required for recent drivers
    open = true;
    # Add a "Battery Saver" boot option to completely disable the dGPU
    primeBatterySaverSpecialisation.enable = true;
  };
  
  # Set a battery charge limit to 80% to improve battery longevity
  hardware.asus.battery.chargeUpto = 80;

  # Podman (replaces Docker)
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  # System-wide packages
  environment.systemPackages = with pkgs; [ git wget btop fastfetch gnome-tweaks ];

  # Enable experimental Nix features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # System state version
  system.stateVersion = "24.05";
}
