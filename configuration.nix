# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports = [
    <home-manager/nixos>
    ./hardware-configuration.nix
  ];

  boot = {
    #extraModulePackages = with config.boot.kernelPackages; [
    #  v4l2loopback.out
    #];
    #kernelModules = [
    #  "v4l2loopback"
    #  "snd-aloop"
    #];
    #extraModprobeConfig = ''
    #  options v4l2loopback exclusive_caps=1 devices=1 card_label="Virtual Camera"
    #'';
    loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "max";
        editor = false;
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };
  };

  system = {
    #copySystemConfiguration = true;
    stateVersion = "22.11";
  };

  sound = {
    enable = true;
  };

  hardware = {
    opengl = {
      enable = true;
    };
    pulseaudio = {
      enable = true;
      systemWide = true;
    };
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  security = {
    polkit = {
      enable = true;
    };
    rtkit = {
      enable = true;
    };
  };

  nixpkgs = {
    overlays = [
      (self: super: { discord = super.discord.overrideAttrs (_: { src = builtins.fetchTarball https://discord.com/api/download?platform=linux&format=tar.gz; });})
    ];
    config = {
      allowUnfree = true;
    };
  };

  xdg = {
    sounds = {
      enable = true;
    };
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-wlr
      ];
      wlr = {
        enable = true;
      };
    };
  };

  networking = {
    hostName = "dell-chan";
    networkmanager = {
      enable = true;
    };
    firewall = {
      enable = false;
      allowedTCPPorts = [
        22
        6600
      ];
    };
  };

  time.timeZone = "Asia/Tokyo";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_CTYPE = "ja_JP.UTF-8";
    };
    inputMethod = {
      enabled = "uim";
      uim = {
        toolbar = "gtk3-systray";
      };
    };
  };

  console = {
    font = "Lat2-Terminus16"; # default fonts setting
    #font = "${pkgs.terminus_font}/share/consolefonts/ter-k24b.psf.gz"; # Verrrrrrrrrry BIG!!!!
    packages = with pkgs; [
      terminus_font
    ];
    keyMap = "us";
  };

  users = {
    #defaultUserShell = pkgs.bash;
    #defaultUserShell = pkgs.zsh;
    defaultUserShell = pkgs.fish;
    mutableUsers = true;
    users = {
      root = {
        isSystemUser = true;
        hashedPassword = "$y$j9T$XnG1STlrSfhuEJkprMPX60$KW3eY3w/F2L.0vGemhdcX7Gi6oFvXAmHVu46bbEuZb7";
        extraGroups = [
          "root"
          "audio"
          "pulse-access"
          "virsh"
          #"pipewire"
        ];
      };
      haruki = {
        isNormalUser = true;
        hashedPassword = "$y$j9T$XnG1STlrSfhuEJkprMPX60$KW3eY3w/F2L.0vGemhdcX7Gi6oFvXAmHVu46bbEuZb7";
        extraGroups = [
          "wheel"
          "docker"
          "audio"
          "pulse-access"
          "virsh"
          "libvirtd"
          #"pipewire"
        ];
      };
      mpd = {
        extraGroups = [
          "audio"
          "pulse-access"
          #"pipewire"
        ];
      };
      pulse = {
        extraGroups = [
          "audio"
          "pulse-access"
        ];
      };
    };
  };

  home-manager = {
    users = {
      root = {
        home = {
          username = "root";
          homeDirectory = "/root";
          stateVersion = "22.11";
        };
        programs = {
          home-manager = {
            enable = true;
          };
          bash = {
            enable = true;
          };
          zsh = {
            enable = true;
            dotDir = ".config/zsh";
            enableCompletion = true;
            enableSyntaxHighlighting = true;
            #sessionVariables = {
            #  #PS1 = "%n@%m:%~/ >";
            #  #PS1 = "%~:%D|%T \n%n@%m >";
            #  PS1 = "hoge >";
            #  PROMPT = "hoge >";
            #};
          };
          fish = {
            enable = true;
            interactiveShellInit = ''
              # commandline color
              set fish_color_normal white
              set fish_color_command brcyan
              set fish_color_autosuggestion brblack
              set fish_color_comment brblack
              set fish_color_error brred
              set fish_color_param bryellow
              #set fish_color_match brcran --underline --background=white
              #set fish_color
              #set fish_color
              #set fish_color
              #set fish_color
              #set fish_color
              #set fish_color
              #set fish_color
              #set fish_color

              # i want to stop greeting by fish-chan.
              set fish_greeting

              # PROMPT settings
              function fish_prompt
                set_color purple
                echo -en "\n"(whoami)@(prompt_hostname):(pwd) "> "
              end
              function fish_right_prompt
                set_color green
                date
              end
            '';
          };
          vim = {
            enable = true;
            extraConfig = ''
              syntax on
              set number
              colorscheme desert
            '';
            plugins = with pkgs.vimPlugins; [
              coc-nvim
            ];
          };
          neovim = {
            enable = true;
            extraConfig = ''
              syntax on
              set number
            '';
            withNodeJs = true;
            coc = {
              enable = true;
              settings = {
                "suggest.enablePreview" = true;
                languageserver = {
                  dockerfile = {
                    command = "coc-docker";
                    filetypes = [ "Dockerfile" ];
                  };
                };
              };
            };
          };
        };
      };
      haruki = {
        home = {
          username = "haruki";
          homeDirectory = "/home/haruki";
          stateVersion = "22.11";
          #mimeApps = {
          #  enable = true;
          #  defaultApplications = {
          #    "application/html" = [
          #      "google-chrome"
          #    ];
          #  };
          #};
          pointerCursor = {
            name = "Adwaita";
            package = pkgs.gnome.adwaita-icon-theme;
            size = 24;
          };
        };
        gtk = {
          enable = true;
        };
        xsession = {
          windowManager = {
            i3 = let
              cfg = config.home-manager.users.haruki.xsession.windowManager.i3.config;
            in {
              enable = true;
              config = {
                menu = "${pkgs.dmenu}/bin/dmenu_run";
                modifier = "Mod4";
                terminal = "alacritty";
                keybindings = {
                  "${cfg.modifier}+Return" = "exec --no-startup-id ${cfg.terminal}";
                  "${cfg.modifier}+t" = "exec --no-startup-id ${cfg.menu}";
                  "${cfg.modifier}+Shift+b" = "exec --no-startup-id google-chrome-stable";
                  "${cfg.modifier}+Shift+d" = "exec --no-startup-id discord";
                  "${cfg.modifier}+p" = "exec --no-startup-id grim";
                  "${cfg.modifier}+Shift+i" = "exec --no-startup-id VirtualBox";
                  "${cfg.modifier}+Shift+g" = "exec --no-startup-id godot";
                  "${cfg.modifier}+Shift+m" = "exec --no-startup-id code";
                  "${cfg.modifier}+Shift+o" = "exec --no-startup-id obs";
                  "${cfg.modifier}+semicolon" = "exec pavucontrol";

                  "${cfg.modifier}+Shift+c" = "reload";
                  "${cfg.modifier}+Shift+e" = "exec i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? ' -b 'Yes' 'i3-msg exit'";
                  "${cfg.modifier}+Shift+q" = "kill";

                  "${cfg.modifier}+Left" = "focus left";
                  "${cfg.modifier}+Down" = "focus down";
                  "${cfg.modifier}+Up" = "focus up";
                  "${cfg.modifier}+Right" = "focus right";

                  "${cfg.modifier}+Shift+Left" = "move left";
                  "${cfg.modifier}+Shift+Down" = "move down";
                  "${cfg.modifier}+Shift+Up" = "move up";
                  "${cfg.modifier}+Shift+Right" = "move right";

                  "${cfg.modifier}+h" = "splith";
                  "${cfg.modifier}+v" = "splitv";
                  "${cfg.modifier}+f" = "fullscreen toggle";
                  "${cfg.modifier}+a" = "focus parent";

                  "${cfg.modifier}+s" = "layout stacking";
                  "${cfg.modifier}+w" = "layout tabbed";
                  "${cfg.modifier}+e" = "layout toggle split";

                  "${cfg.modifier}+Shift+space" = "floating toggle";
                  "${cfg.modifier}+space" = "focus mode_toggle";

                  "${cfg.modifier}+1" = "workspace number 1";
                  "${cfg.modifier}+2" = "workspace number 2";
                  "${cfg.modifier}+3" = "workspace number 3";
                  "${cfg.modifier}+4" = "workspace number 4";
                  "${cfg.modifier}+5" = "workspace number 5";
                  "${cfg.modifier}+6" = "workspace number 6";
                  "${cfg.modifier}+7" = "workspace number 7";
                  "${cfg.modifier}+8" = "workspace number 8";
                  "${cfg.modifier}+9" = "workspace number 9";

                  "${cfg.modifier}+Shift+1" = "move container to workspace number 1";
                  "${cfg.modifier}+Shift+2" = "move container to workspace number 2";
                  "${cfg.modifier}+Shift+3" = "move container to workspace number 3";
                  "${cfg.modifier}+Shift+4" = "move container to workspace number 4";
                  "${cfg.modifier}+Shift+5" = "move container to workspace number 5";
                  "${cfg.modifier}+Shift+6" = "move container to workspace number 6";
                  "${cfg.modifier}+Shift+7" = "move container to workspace number 7";
                  "${cfg.modifier}+Shift+8" = "move container to workspace number 8";
                  "${cfg.modifier}+Shift+9" = "move container to workspace number 9";

                  "${cfg.modifier}+r" = "mode resize";
                };
                modes = {
                  resize = {
                    "Left" = "resize shrink width 10 px";
                    "Down" = "resize grow height 10 px";
                    "Up" = "resize shrink height 10 px";
                    "Right" = "resize grow width 10 px";
                    "Escape" = "mode default";
                    "Return" = "mode default";
                  };
                };
                fonts = {
                  names = [
                    "monospace"
                  ];
                  size = 8.0;
                };
                bars = [
                  {
                    "hiddenState" = "show";
                    "position" = "top";
                    "statusCommand" = "while date; do sleep 1; done"; # bash style
                    #"statusCommand" = "while true; date; sleep 1; end"; # fish style
                  }
                ];
              };
            };
          };
        };
        wayland = {
          windowManager = {
            sway = let
              cfg = config.home-manager.users.haruki.wayland.windowManager.sway.config;
            in {
              enable = true;
              wrapperFeatures = {
                gtk = true;
              };
              xwayland = true;
              config = {
                menu = "${pkgs.wofi}/bin/wofi -S drun";
                modifier = "Mod4";
                terminal = "foot";
                #startup = [
                #  { 
                #    command = "uim-xim";
                #  }
                #  { command = "export LC_ALL=ja_JP.UTF-8"; }
                #];
                keybindings = {
                  "${cfg.modifier}+Return" = "exec --no-startup-id ${cfg.terminal}";
                  "${cfg.modifier}+t" = "exec --no-startup-id ${cfg.menu}";
                  "${cfg.modifier}+Shift+b" = "exec --no-startup-id google-chrome-stable";
                  "${cfg.modifier}+Shift+d" = "exec --no-startup-id discord";
                  "${cfg.modifier}+p" = "exec --no-startup-id grim";
                  "${cfg.modifier}+Shift+i" = "exec --no-startup-id VirtualBox";
                  "${cfg.modifier}+Shift+g" = "exec --no-startup-id godot";
                  "${cfg.modifier}+Shift+m" = "exec --no-startup-id code";
                  "${cfg.modifier}+Shift+o" = "exec --no-startup-id obs";
                  "${cfg.modifier}+semicolon" = "exec --no-startup-id pavucontrol";

                  "${cfg.modifier}+Shift+c" = "reload";
                  "${cfg.modifier}+Shift+e" = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";
                  "${cfg.modifier}+Shift+q" = "kill";

                  "${cfg.modifier}+Left" = "focus left";
                  "${cfg.modifier}+Down" = "focus down";
                  "${cfg.modifier}+Up" = "focus up";
                  "${cfg.modifier}+Right" = "focus right";

                  "${cfg.modifier}+Shift+Left" = "move left";
                  "${cfg.modifier}+Shift+Down" = "move down";
                  "${cfg.modifier}+Shift+Up" = "move up";
                  "${cfg.modifier}+Shift+Right" = "move right";

                  "${cfg.modifier}+h" = "splith";
                  "${cfg.modifier}+v" = "splitv";
                  "${cfg.modifier}+f" = "fullscreen toggle";
                  "${cfg.modifier}+a" = "focus parent";

                  "${cfg.modifier}+s" = "layout stacking";
                  "${cfg.modifier}+w" = "layout tabbed";
                  "${cfg.modifier}+e" = "layout toggle split";

                  "${cfg.modifier}+Shift+space" = "floating toggle";
                  "${cfg.modifier}+space" = "focus mode_toggle";

                  "${cfg.modifier}+1" = "workspace number 1";
                  "${cfg.modifier}+2" = "workspace number 2";
                  "${cfg.modifier}+3" = "workspace number 3";
                  "${cfg.modifier}+4" = "workspace number 4";
                  "${cfg.modifier}+5" = "workspace number 5";
                  "${cfg.modifier}+6" = "workspace number 6";
                  "${cfg.modifier}+7" = "workspace number 7";
                  "${cfg.modifier}+8" = "workspace number 8";
                  "${cfg.modifier}+9" = "workspace number 9";

                  "${cfg.modifier}+Shift+1" = "move container to workspace number 1";
                  "${cfg.modifier}+Shift+2" = "move container to workspace number 2";
                  "${cfg.modifier}+Shift+3" = "move container to workspace number 3";
                  "${cfg.modifier}+Shift+4" = "move container to workspace number 4";
                  "${cfg.modifier}+Shift+5" = "move container to workspace number 5";
                  "${cfg.modifier}+Shift+6" = "move container to workspace number 6";
                  "${cfg.modifier}+Shift+7" = "move container to workspace number 7";
                  "${cfg.modifier}+Shift+8" = "move container to workspace number 8";
                  "${cfg.modifier}+Shift+9" = "move container to workspace number 9";

                  "${cfg.modifier}+r" = "mode resize";
                };
                modes = {
                  resize = {
                    "Left" = "resize shrink width 10 px";
                    "Down" = "resize grow height 10 px";
                    "Up" = "resize shrink height 10 px";
                    "Right" = "resize grow width 10 px";
                    "Escape" = "mode default";
                    "Return" = "mode default";
                  };
                };
                window = {
                  border = 0;
                };
                fonts = {
                  names = [
                    "monospace"
                  ];
                  size = 8.0;
                };
                gaps = {
                  inner = 1;
                  outer = 1;
                };
                output = {
                  "*" = {
                    bg = "/etc/wallpaper/nix-wallpaper-simple-dark-gray.png fill";
                  };
                };
                bars = [
                  {
                    "hiddenState" = "show";
                    "command" = "${pkgs.waybar}/bin/waybar"; # Using WayBar
                    #"statusCommand" = "while date; do sleep 1; done"; # bash style
                    #"statusCommand" = "while true; date; sleep 1; end"; # fish style
                  }
                ];
              };
            };
          };
        };
        programs = {
          home-manager = {
            enable = true;
          };
          bash = {
            enable = true;
          };
          zsh = {
            enable = true;
            dotDir = ".config/zsh";
            enableCompletion = true;
            enableSyntaxHighlighting = true;
            #sessionVariables = {
            #  PS1 = "%n@%m:%~/ >";
            #};
          };
          fish = {
            enable = true;
            interactiveShellInit = ''
              set fish_greeting

              set fish_color_normal white
              set fish_color_command brcyan
              set fish_color_autosuggestion brblack
              set fish_color_comment brblack
              set fish_color_error brred
              set fish_color_param bryellow

              function fish_prompt
                set_color cyan
                echo -en "\n"(whoami)@(prompt_hostname):(pwd) "> "
              end
              function fish_right_prompt
                set_color green
                date
              end
            '';
          };
          urxvt = {
            enable = true;
            #transparent = true;
            #shading = 15;
            fonts = [
              "xft:Dejavu:size=8"
            ];
            extraConfig = {
              "scrollBar" = "false";

              "background" = "#101010";
              "foreground" = "#CCCCCC";
              "color0" = "#101010";
              "color1" = "#960050";
              "color2" = "#66aa11";
              "color3" = "#c47f2c";
              "color4" = "#30309b";
              "color5" = "#7e40a5";
              "color6" = "#3579a8";
              "color7" = "#9999aa";
              "color8" = "#303030";
              "color9" = "#ff0090";
              "color10" = "#80ff00";
              "color11" = "#ffba68";
              "color12" = "#5f5fee";
              "color13" = "#bb88dd";
              "color14" = "#4eb4fa";
              "color15" = "#d0d0d0";
            };
          };
          foot = {
            enable = true;
            server.enable = true;
            settings = {
              colors = {
                alpha = 0.5;
              };
            };
          };
          git = {
            enable = true;
            userName = "haruki7049";
            userEmail = "tontonkirikiri@gmail.com";
          };
          waybar = {
            enable = true;
            settings = {
              mainBar = {
                leyer = "top";
                position = "top";
                modules-left = [ "sway/workspaces" "sway/mode" ];
                modules-center = [ "clock" "mpd" ];
                modules-right = [ "network" "tray" ];
                "network" = {
                  "format" = "{ifname}";
                  "format-disconnected" = "disconnected";
                  "format-wifi" = "{essid}, {ipaddr}: ({signalStrength}%)";
                  "format-ethernet" = "{ifname}, {ipaddr}";
                };
                #"pulseaudio" = {
                #  format = "{desc}:{volume}% Mic:{format-source}";
                #  format-bluetooth = "bluetooth: {desc} {volume}%";
                #  format-muted = "Speaker muted";#Speaker
                #  format-source-muted = "Mic muted";#Mic
                #};
                "clock" = {
                  timezone = "Asia/Tokyo";
                  format = "{:%F %H:%M %A}";
                };
                "sway/workspaces" = {
                  disable-scroll = true;
                  all-outputs = true;
                };
              };
            };
            style = ''
              * {
                font-family: FontAwesome, Roboto, Helvetica, Arial, sans-serif;
                font-size: 10px;
                color: #000000;
                border: none;
                border-radius: 0;
                padding: 0;
                margin: 0;
              }
              #workspaces button {
                border-bottom: 2px solid #696969;
                background: #666666;
              }
              #workspaces button.focused {
                border-bottom: 2px solid #696969;
                background: #888888;
              }
              #clock {
                font-weight: 900;
                padding: 0 5px;
                border: 2px solid #696969;
                background: #888888;
              }
              #network {
                border: 2px solid #696969;
                padding: 0 5px;
                background: #888888;
              }
              #pulseaudio {
                border: 2px solid #696969;
                padding: 0 5px;
                background: #888888;
              }
              #mpd {
                border: 2px solid #696969;
                padding: 0 5px;
                background: #888888;
              }
              #tray {
                border: 2px solid #696969;
                padding: 0 5px;
                background: #888888;
              }
            '';
          };
          swaylock = {
            settings = {
              color = "505050";
            };
          };
          mako = {
            enable = true;
            font = "FontAwesome 10";
          };
          vim = {
            enable = true;
            extraConfig = ''
              syntax on
              set number
              colorscheme desert
            '';
            plugins = with pkgs.vimPlugins; [
              coc-nvim
              molokai
              vim-hybrid
            ];
          };
          neovim = {
            enable = true;
            extraConfig = ''
              syntax on
              set number
            '';
            withNodeJs = true;
            coc = {
              enable = true;
              settings = {
                "suggest.enablePreview" = true;
                languageserver = {
                  dockerfile = {
                    command = "coc-docker";
                    filetypes = [ "Dockerfile" ];
                  };
                };
              };
            };
          };
        };
      };
    };
  };

  environment = {
    systemPackages = with pkgs; [
      # CLI
      ## Common commands
      vim
      wget
      tmux
      alsa-utils
      pulseaudio
      mpc-cli
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
      nodejs
      #rustup
      #go
      #clang
      #gcc
      #clisp
      #dotnet-sdk
      #qemu
      #processing
      godot
      pkg-config
      
      # GUI
      ## libvirt manager
      virt-manager
      virt-viewer

      ## Browsers
      chromium

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
      #minecraft
    ];
    variables = {
      EDITOR = "vim";
    };
    sessionVariables = {
      GTK_THEME = "Adwaita:dark";
      GTK_IM_MODULE = "uim";
      QT_IM_MODULE = "uim";
      CLUTTER_IM_MODULE = "xim";
      XMODIFIRES = "@im=xim";
    };
    shells = with pkgs; [
      zsh
      fish
    ];
  };

  fonts = {
    fonts = with pkgs; [
      dejavu_fonts
      ipafont
      ipaexfont
      noto-fonts
      noto-fonts-emoji
      noto-fonts-extra
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif

      font-awesome
      hack-font
      roboto
      helvetica-neue-lt-std
    ];
    fontconfig.defaultFonts = {
      serif = [ "Noto Serif" ];
      sansSerif = [ "Noto Sans" ];
    };
  };

  systemd = {
    services = {
      NetworkManager-wait-online = {
        enable = false;
      };
    };
  };

  programs = {
    zsh = {
      enable = true;
      #promptInit = ''
      #  
      #'';
    };
    fish = {
      enable = true;
    };
    sway = {
      enable = true;
      extraPackages = with pkgs; [
        swaylock
        swayidle
        foot
        wofi
        waybar
      ];
    };
  };

  services = {
    #greetd = {
    #  enable = true;
    #  settings = {
    #    default_session = {
    #      command = "${lib.makeBinPath [pkgs.greetd.tuigreet] }/tuigreet -c bash";
    #      user = "greeter";
    #    };
    #  };
    #};
    xserver = {
      enable = true;
      layout = "us";
      libinput = {
        enable = true;
      };
      displayManager = {
        startx = {
          enable = true;
        };
      };
      windowManager = {
        i3 = {
          enable = true;
          extraPackages = with pkgs; [
            dmenu
            i3status
            i3lock
          ];
        };
      };
    };
    picom = {
      enable = true;
      vSync = true;
      backend = "glx";
    };
    upower = {
      enable = true;
    };
    dbus = {
      enable = true;
    };
    postgresql = {
      package = pkgs.postgresql;
      enable = true;
    };
    #mysql = {
    #  package = pkgs.mysql80;
    #  enable = true;
    #};
    openssh = {
      enable = true;
    };
    #pipewire = {
    #  enable = false;
    #  systemWide = true;
    #  wireplumber = {
    #    enable = true;
    #  };
    #  alsa = {
    #    enable = true;
    #    support32Bit = true;
    #  };
    #  pulse.enable = true;
    #  config = {
    #    pipewire = {
    #      context.properties = {
    #        core.daemon = true;
    #        support.dbus = true;
    #      };
    #      context.modules = {
    #        name = "libpipewire-portal";
    #      };
    #    };
    #  };
    #};
    mpd = {
      enable = true;
      network = {
        port = 6600;
        listenAddress = "any";
      };
      extraConfig = ''
        restore_paused "yes"
        audio_output {
          type "pulse"
          name "pulseaudio"
        }
      '';
    };
  };

  virtualisation = {
    #libvirtd = {
    #  enable = true;
    #  allowedBridges = [
    #    "virbr0"
    #  ];
    #};
    docker = {
      enable = true;
    };
    #virtualbox = {
    #  host = {
    #    enable = true;
    #  };
    #};
  };
}
