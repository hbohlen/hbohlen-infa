# /mnt/etc/nixos/flake.nix
{
  description = "Hayden's NixOS configuration for Zephyrus M16";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    disko.url = "github:nix-community/disko";
  };

  outputs = { self, nixpkgs, disko, ... }: {
    nixosConfigurations = {
      # This name "zephyrus" will be used in the install command.
      zephyrus = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          disko.nixosModules.disko
          ./disko-config.nix # <-- Importing your new disk config
          ./configuration.nix # <-- Importing your main system config
        ];
      };
    };
  };
}
