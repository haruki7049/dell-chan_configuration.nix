{ config, lib, pkgs, ... }:
{
  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot"; # EFI Mount Point which partition should use fat32
  };
}
