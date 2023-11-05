{
  pkgs,
  config,
  lib,
  ...
}: {
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
    username = "k";
    homeDirectory = "/home/k";
    stateVersion = "23.05";
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.

  # Let Home Manager install and manage itself.
  programs = {
    home-manager.enable = true;
  };

  # Imports
  imports = [
    ./cli
    ./dev
    # ./pkgs
    ./system
    ./themes
    ./services
    ./graphical
  ];

  # Overlays
  nixpkgs = {
    overlays = [
      /*(self: super: {
        discord = super.discord.overrideAttrs (
          _: {
            src = builtins.fetchTarball {
              url = "https://discord.com/api/download?platform=linux&format=tar.gz";
              sha256 = "";
            };
          }
        );
      })*/
      # (import (builtins.fetchTarball {
      #   url = "https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz";
      # }))
      (import ../../overlays/firefox-overlay.nix)
    ];
    config = {
      allowUnfreePredicate = pkg: true;
      packageOverrides = pkgs: {
        # integrates nur within Home-Manager
        nur =
          import
          (builtins.fetchTarball {
            url = "https://github.com/nix-community/NUR/archive/master.tar.gz";
            sha256 = "sha256:1gr3l5fcjsd7j9g6k9jamby684k356a36h82cwck2vcxf8yw8xa0";
          })
          {inherit pkgs;};
      };
    };
  };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # personnal tools
    kubectl
    brave
    vscode
    bottles
    discord
    lens
    protonvpn-gui
    rustdesk
    jetbrains-toolbox
    wdisplays
    drawio
    #obs-studio
    signal-desktop
    cinnamon.bulky
    yuzu-early-access
    hakuneko
    wireshark
    obsidian
    yubikey-manager
    protonmail-bridge
    ledger-live-desktop
    popsicle
    monero-gui
    libreoffice-fresh
    meld
  ];

  # xdg.configFile."nvim".source = "${(pkgs.callPackage ./pkgs/nvchad.nix {})}";
  # home.file = {
  #   # Add nvchad
  #   ".config/nvim" = {
  #     source = "${(pkgs.callPackage ./pkgs/nvchad.nix {})}";
  #     recursive = true;
  #   };
  # };

  fonts.fontconfig.enable = true;

  # Add support for .local/bin
  home.sessionPath = [
    "$HOME/.local/bin"
  ];
}
