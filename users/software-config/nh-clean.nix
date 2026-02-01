{ ... }: {
  programs.nh.enable = true;
  programs.nh.flake = "/home/qb114514/nixos-conf";
  programs.nh.clean.enable = true;
  programs.nh.clean.dates = "weekly";
}
