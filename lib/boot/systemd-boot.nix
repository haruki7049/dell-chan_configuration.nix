{ config, lib, pkgs, ... }:
{
  boot.loader.systemd-boot = {
    enable = true;
    consoleMode = "max";
    editor = false;
  };
}
