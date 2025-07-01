{ pkgs, ... }: {
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
    gh
    nh
    just
    cached-nix-shell

    # Printers
    bat
    delta

    # TUI
    fastfetch
    yazi
  ];

  imports = [
    ./terminal.nix
  ];
}
