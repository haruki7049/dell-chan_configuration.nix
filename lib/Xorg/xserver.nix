{ config, lib, pkgs, ... }:
{
  services.xserver = {
    enable = true;
    layout = "us";
    libinput.enable = true;
    displayManager.startx.enable = true;
  };
}
