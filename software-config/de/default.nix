{ pkgs, ... }: {
  home.packages = with pkgs; [
    # Launcher
    fuzzel
  ];

  imports = [
    ./niri.nix
    ./eww.nix
    ./notify.nix
  ];
}
