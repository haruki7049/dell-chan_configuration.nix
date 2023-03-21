{ config, lib, pkgs, ... }:
{
  services.pipewire = {
    enable = true;
    systemWide = true;
    wireplumber.enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    config = {
      pipewire = {
        context = {
          properties = {
            core.daemon = true;
            support.dbus = true;
          };
          modules = {
            name = "libpipewire-portal";
          };
        };
      };
    };
  };
}
