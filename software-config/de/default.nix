{ pkgs, ... }: {
  home.packages = with pkgs; [
    # Launcher
    fuzzel
  ];

  imports = [
    ./eww.nix
    ./notify.nix
    ./osd-user.nix
  ];
}
