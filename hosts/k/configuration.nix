# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  final,
  prev,
  inputs,
  packages,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  boot = {
    # Kernel Modules
    kernelModules = ["v4l2loopback"]; # Autostart kernel modules on boot
    extraModulePackages = with config.boot.kernelPackages; [v4l2loopback]; # loopback module to make OBS virtual camera work
    # Bootloader.
    loader = {
      systemd-boot.enable = false;
      timeout = 10;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };

      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
        #configurationLimit = 5;

        # theme = pkgs.fetchFromGitHub {
        #   owner = "shvchk";
        #   repo = "fallout-grub-theme";
        #   rev = "80734103d0b48d724f0928e8082b6755bd3b2078";
        #   sha256 = "sha256-7kvLfD6Nz4cEMrmCA9yq4enyqVyqiTkVZV5y4RyUatU=";
        # };

        #   theme = (pkgs.fetchFromGitHub
        #     {
        #       owner = "catppuccin";
        #       repo = "grub";
        #       rev = "803c5df0e83aba61668777bb96d90ab8f6847106";
        #       sha256 = "sha256-/bSolCta8GCZ4lP0u5NVqYQ9Y3ZooYCNdTwORNvR7M0=";
        #     } + "/src/catppuccin-mocha-grub-theme");
        # };

        theme =
          pkgs.fetchFromGitHub
          {
            owner = "semimqmo";
            repo = "sekiro_grub_theme";
            rev = "1affe05f7257b72b69404cfc0a60e88aa19f54a6";
            sha256 = "02gdihkd2w33qy86vs8g0pfljp919ah9c13cj4bh9fvvzm5zjfn1";
          }
          + "/Sekiro";
      };
    };

    initrd.luks.devices."luks-f99c1661-287c-4067-8abe-d258cc39c679".device = "/dev/disk/by-uuid/f99c1661-287c-4067-8abe-d258cc39c679";

    # theme = pkgs.fetchFromGitHub
    #   {
    #     owner = "Lxtharia";
    #     repo = "minegrub-theme";
    #     rev = "193b3a7c3d432f8c6af10adfb465b781091f56b3";
    #     sha256 = "1bvkfmjzbk7pfisvmyw5gjmcqj9dab7gwd5nmvi8gs4vk72bl2ap";
    #   };

    #   theme =
    #     pkgs.fetchFromGitHub
    #     {
    #       owner = "Patato777";
    #       repo = "dotfiles";
    #       rev = "d6f96fa59327a936d335f01a7295815250f96ff7";
    #       sha256 = "18mra67kd20bld5zxlvb89ik8psr2pj0v9iaizqpd485sywgqwiq";
    #     }
    #     + "/grub/themes/virtuaverse";
    # };
  };

  networking = {
    # no need to wait interfaces to have an IP to continue booting
    dhcpcd.wait = "background";
    hostName = "ey"; # Define your hostname.
    # avoid checking if IP is already taken to boot a few seconds faster
    #dhcpcd.extraConfig = "noarp";
    # Enable networking
    networkmanager.enable = true;
  };

  systemd.services.NetworkManager-wait-online.enable = false;
  #  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  # Configure console keymap
  console.keyMap = "us";

  # Configure keymap in X11
  services = {
    # Enable CUPS to print documents.
    printing.enable = true;
    # printing.enable = true;
    xserver = {
      # Enable the X11 windowing system.
      enable = true;

      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      
      layout = "us";
      xkbVariant = "alt-intl";
      libinput = {
        enable = true;
        mouse.accelProfile = "flat";
        touchpad.accelProfile = "flat";
      };
    };
  };

  # Enables services
  # services.logmein-hamachi.enable = true;
  # services.flatpak.enable = true;

  # Enable programs
  programs = {
    zsh.enable = true;
    dconf.enable = true;
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };
  };

  # Use overlays
  nixpkgs.overlays = [
    (
      final: prev: {
        sf-mono-liga-bin = prev.stdenvNoCC.mkDerivation rec {
          pname = "sf-mono-liga-bin";
          version = "dev";
          src = inputs.sf-mono-liga-src;
          dontConfigure = true;
          installPhase = ''
            mkdir -p $out/share/fonts/opentype
            cp -R $src/*.otf $out/share/fonts/opentype/
          '';
        };
      }
    )
  ];

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      sf-mono-liga-bin
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = ["Times, Noto Serif"];
        sansSerif = ["Helvetica Neue LT Std, Helvetica, Noto Sans"];
        monospace = ["Courier Prime, Courier, Noto Sans Mono"];
      };
    };
  };

  # programs.steam.enable = true;
  # programs.haguichi.enable = true;

  # Enables docker in rootless mode
  virtualisation = {
    docker.rootless = {
      enable = true;
      setSocketVariable = true;
    };
    # Enables virtualization for virt-manager
    libvirtd.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  services.xserver.videoDrivers = ["intel"];

  environment = {
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      #WLR_NO_HARDWARE_CURSORS = "1";
      DEFAULT_BROWSER = "${pkgs.brave}/bin/brave"; # Set default browser
    };
    systemPackages = with pkgs; [
      git
      wget
      playerctl
      inputs.xdg-portal-hyprland.packages.${system}.xdg-desktop-portal-hyprland
    ];
  };

  hardware = {
    opengl.enable = true;
    opengl.driSupport32Bit = true;
  };

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
    #jack.enable = true;
  };

  users.users.k = {
    isNormalUser = true;
    description = "k";
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
      "input"
      "docker"
      "libvirtd"
    ];
  };

  # Use doas instead-of sudo
  security = {
    sudo.enable = false;
    doas = {
      enable = true;
      wheelNeedsPassword = true;
      extraRules = [
        {
          users = ["k"];
          keepEnv = true;
          persist = true;
        }
      ];
    };
  };

  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
  };

  # Enables flakes + garbage collector
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
    settings = {
      auto-optimise-store = true;
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
  
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
