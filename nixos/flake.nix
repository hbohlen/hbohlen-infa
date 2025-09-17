{
  description = "Hayden's NixOS configuration for Zephyrus M16";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    disko.url = "github:nix-community/disko";
  };

  outputs = { self, nixpkgs, nixos-hardware, disko, ... }: {
    nixosConfigurations = {
      "zephyrus-m16" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          # Base hardware profile for your laptop
          nixos-hardware.nixosModules.asus-zephyrus-gu603h

          # Optional hardware modules for extra features
          nixos-hardware.nixosModules.asus-battery
          nixos-hardware.nixosModules.asus-zephyrus-shared-backlight

          # Your disk configuration and main system config
          disko.nixosModules.disko
          ./disko-config.nix
          ./configuration.nix
        ];
      };
    };
  };
}