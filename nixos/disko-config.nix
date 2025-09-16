# /mnt/etc/nixos/disko-config.nix
{ disko, ... }:
{
  disko.devices = {
    disk = {
      # This specifies which disk to partition.
      nvme0n1 = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt"; # Create a GPT partition table.
          partitions = {
            # 1. The EFI/boot partition
            ESP = {
              size = "1G";
              type = "EF00"; # Standard EFI partition type
              content = {
                type = "filesystem";
                format = "vfat"; # FAT32 filesystem
                mountpoint = "/boot";
              };
            };

            # 2. The Swap partition
            swap = {
              size = "16G";
              content = {
                type = "swap";
                randomEncryption = true;
              };
            };

            # 3. The Root partition (using the rest of the disk)
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "btrfs"; # Using the Btrfs filesystem
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };
}
