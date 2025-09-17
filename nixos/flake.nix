# flake.nix

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
          nixos-hardware.nixosModules.asus-zephyrus-gu603h,

          # Optional hardware module for battery control
          nixos-hardware.nixosModules.asus-battery,
          
          # ⭐️ REMOVED the shared-backlight module from here ⭐️

          # Your disk configuration and main system config
          disko.nixosModules.disko,
          ./disko-config.nix,
          ./configuration.nix
        ];
      };
    };
  };
}