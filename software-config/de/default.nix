{ pkgs, ... }: {
  home.packages = with pkgs; [
    niri

    # Launcher
    fuzzel
  ];

  home.file.".config/niri/config.kdl".source = ./niri.kdl;

  imports = [
    ./bar.nix
  ];
}
