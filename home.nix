{config, pkgs, ...}: {
  home.username = "qb114514";
  home.homeDirectory = "/home/qb114514";

  home.packages = with pkgs; [
    # Zipping
    zip
    xz 
    unzip

    # Monitors
    iftop
    btop
    htop
    iotop

    # Utils
    file
    which
    tree
    ripgrep
    jq
    fzf

    # TUI
    fastfetch
    yazi

    # Bridge between T/GUI
    wl-clipboard
    
    # GUI
    alacritty
    fuzzel
    i3bar-river
    i3blocks
  ];

  programs.git = {
    enable = true;
    userName = "qb114514";
    userEmail = "GNUqb114514@outlook.com";
  };

  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  imports = [
    software-config/alacritty.nix
    software-config/firefox.nix
    software-config/gui.nix
  ];
}
