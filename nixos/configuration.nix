# /mnt/etc/nixos/configuration.nix

{ config, pkgs, ... }:

{
  # Bootloader. We use systemd-boot, which you had success with.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Set your time zone (Omaha, NE is in America/Chicago).
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Define a user account.
  users.users.hbohlen = {
    isNormalUser = true;
    description = "Hayden";
    extraGroups = [ "networkmanager" "wheel" ]; # "wheel" allows sudo
  };

  # Set your hostname.
  networking.hostName = "zephyrus";

  # Allow unfree packages (for NVIDIA drivers).
  nixpkgs.config.allowUnfree = true;

  # Enable networking.
  networking.networkmanager.enable = true;

  # ----------------------------------------------------------------- #
  # 🖥️ DESKTOP & GRAPHICS CONFIGURATION (THE IMPORTANT PART)
  # ----------------------------------------------------------------- #
  
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  
  # NVIDIA DRIVERS
  # This section enables the proprietary NVIDIA driver.
  services.xserver.videoDrivers = [ "nvidia" ];

  # Enable NVIDIA PRIME Render Offload for hybrid graphics.
  # This lets the system use the Intel iGPU for light tasks
  # and the NVIDIA dGPU for demanding applications.
  hardware.nvidia.prime = {
    sync.enable = true;

    # These Bus IDs tell NixOS which card is which.
    # You can verify these with the `lspci` command, but these
    # are standard for most Intel/NVIDIA laptops.
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  # ----------------------------------------------------------------- #
  # 📦 SOFTWARE PACKAGES
  # ----------------------------------------------------------------- #
  
  # List packages you want to install system-wide.
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    firefox
    # Add more here
  ];


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Or whatever version you're installing

}
