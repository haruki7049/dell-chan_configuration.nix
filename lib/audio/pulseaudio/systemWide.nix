{ config, lib, pkgs, ... }:
{
  hardware = {
    pulseaudio = {
      enable = true;
      systemWide = true;
    };
  };
}
