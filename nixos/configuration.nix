{ config, pkgs, ... }:

{
  # The main hardware profile and optional modules (battery, backlight)
  # are now imported by your flake.nix

  # Bootloader and Kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "quiet" "splash" ];

  # User Account and System Info
  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.UTF-8";
  users.users.hbohlen = {
    isNormalUser = true;
    description = "Hayden";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
  };
  networking.hostName = "zephyrus-m16";

  # Allow unfree packages for NVIDIA drivers
  nixpkgs.config.allowUnfree = true;

  # Essential Services and Daemons for this hardware
  services = {
    # For ROG hardware control and GPU switching
    asusd.enable = true;
    asusd.enableUserService = true;
    supergfxd.enable = true;

    # GNOME Desktop Environment
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
  };
  # Fix for supergfxctl graphics card detection
  systemd.services.supergfxd.path = [ pkgs.pciutils ];

  # Essential Hardware Configuration
  hardware.enableRedistributableFirmware = true; # For the Intel Wi-Fi card

  # Podman container engine
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  # System-wide packages
  environment.systemPackages = with pkgs; [ git wget btop fastfetch gnome-tweaks ];

  # Enable modern Nix features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "24.05";
}
