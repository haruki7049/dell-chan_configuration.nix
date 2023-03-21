{ config, lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # CLI
    ## Common commands
    vim
    wget
    tmux
    alsa-utils
    pulseaudio
    w3m
    neofetch

    ## Networking
    bridge-utils

    ## system packages
    alsa-lib
    libudev-zero

    ## Joke commands
    cmatrix
    sl

    ## Programming langs
    ### C language compiler
    clang
    ### Rust-lang
    cargo
    rustc
    ### JavaScript runtime
    deno
    nodejs
    ### Godot
    godot
  
    # GUI
    ## libvirt manager
    virt-manager
    virt-viewer

    ## Browsers
    chromium
    firefox-wayland

    ## Image viewers
    imv
    mpv

    ## Image editors
    gimp
    blender

    ## Audio editors
    audacity

    ## Recorders
    grim
    obs-studio
    ffmpeg
    wf-recorder
    slurp

    ## Terminals
    xterm
    alacritty
    wezterm

    ## Volumes
    pavucontrol
    helvum

    # Unfree
    google-chrome
    discord
    vscode
  ];
}
