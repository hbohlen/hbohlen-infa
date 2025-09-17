# configuration.nix

{ config, pkgs, ... }:

{
  # Bootloader, Kernel, and Hardware Tweaks
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    # ⭐️ ADDED THIS BLOCK ⭐️
    # Manually add kernel parameters from asus/zephyrus/shared/backlight.nix
    # to fix screen brightness control in hybrid graphics mode.
    kernelParams = [
      "quiet"
      "splash"
      "i915.enable_dpcd_backlight=1"
      "nvidia.NVreg_EnableBacklightHandler=0"
      "nvidia.NVReg_RegistryDwords=EnableBrightnessControl=0"
    ];
  };

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
    asusd.enable = true;
    asusd.enableUserService = true;
    supergfxd.enable = true;

    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
  };
  systemd.services.supergfxd.path = [ pkgs.pciutils ];

  # Essential Hardware Configuration
  hardware.enableRedistributableFirmware = true; # For the Intel Wi-Fi card
  hardware.asus.battery.chargeUpto = 80; # Set battery charge limit

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