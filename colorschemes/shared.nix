{ pkgs, ... }: {
  stylix.fonts = let
    font = name: package: {inherit name package;};
  in with pkgs; {
    monospace = font "UbuntuMono Nerd Font" nerd-fonts.ubuntu-mono;
    sansSerif = font "Ubuntu Nerd Font" nerd-fonts.ubuntu;
    serif = font "Source Han Serif SC" source-han-serif-simplified-chinese;
    sizes = let
      normal = 13;
      small = 12;
      large = 15;
    in {
      terminal = normal;
      applications = normal;
      desktop = small;
      popups = small;
    };
  };

  stylix.targets.firefox.profileNames = [ "default" ];
}
