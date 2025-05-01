{ pkgs, ... }: {
  home.packages = with pkgs; [
    # Launcher
    fuzzel
  ];

  imports = [
    ./niri.nix
    ./bar.nix
    ./eww.nix
  ];
}
