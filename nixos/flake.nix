# flake.nix
{
  description = "Hayden's NixOS configuration for Zephyrus M16";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
  };

  outputs = { self, nixpkgs, nixos-hardware, ... }: {
    nixosConfigurations = {
      # This name "zephyrus-m16" is what you'll use in the rebuild command
      "zephyrus-m16" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          # Pass the hardware module to the configuration
          nixos-hardware.nixosModules.asus-zephyrus-g603h
          ./configuration.nix
        ];
      };
    };
  };
}
