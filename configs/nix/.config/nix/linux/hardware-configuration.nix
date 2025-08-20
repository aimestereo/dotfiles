{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ ];

  boot.initrd.availableKernelModules = [ "ata_piix" "ahci" "sd_mod" "sr_mod" "xhci_pci" "usbhid" "usb_storage" "nvme" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/5927cdcc-c4a7-45b5-937b-dba50e74faad";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/EB9E-75F4";
      fsType = "vfat";
    };

  swapDevices = [ ];
}

