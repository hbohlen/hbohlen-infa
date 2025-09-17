{ config, pkgs, ... }:

{
  # The hardware import is now handled by your flake.nix

  # Bootloader, Kernel, and Hardware Tweaks
  boot = {
    # Use the latest kernel for the best hardware support
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    # Kernel parameters from asus/zephyrus/shared/backlight.nix
    # These fix screen brightness control in hybrid graphics mode.
    kernelParams = [
      "quiet"
      "splash"
      "i915.enable_dpcd_backlight=1"
      "nvidia.NVreg_EnableBacklightHandler=0"
      "nvidia.NVReg_RegistryDwords=EnableBrightnessControl=0"
    ];
  };
  
  # HiDPI console font for better readability in the TTY
  console.font = "${pkgs.terminus_font}/share/consolefonts/ter-v32n.psf.gz";

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

  # Services and Daemons
  services = {
    # From asus-linux.org: Enables ROG Control Center and GPU switching
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
    
    # Remap function keys like the microphone mute key
    udev.extraHwdb = ''
      evdev:name:*:dmi:bvn*:bvr*:bd*:svnASUS*:pn*:*
       KEYBOARD_KEY_ff31007c=f20
    '';
  };
  # Fix for supergfxctl graphics card detection
  systemd.services.supergfxd.path = [ pkgs.pciutils ];

  # Hardware Configuration
  hardware = {
    # NVIDIA Graphics Configuration
    nvidia = {
      open = true; # Required for newer NVIDIA drivers
      primeBatterySaverSpecialisation.enable = true; # Creates a "Battery Saver" boot option
    };
    
    # From asus/battery.nix: Set a battery charge limit to 80% to improve battery health
    asus.battery.chargeUpto = 80;

    # Enable firmware for the built-in Intel Wi-Fi card
    enableRedistributableFirmware = true;
  };

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
