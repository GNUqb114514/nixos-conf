{ pkgs, ... }: {
  home.packages = with pkgs; [
    # Launcher
    fuzzel
  ];

  imports = [
    ./eww.nix
    ./osd-user.nix
  ];
}
