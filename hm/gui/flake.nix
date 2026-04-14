{
  description = "My simple system configuration - GUI configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";

    systems.url = "github:nix-systems/default";

    flake-parts.url = "github:hercules-ci/flake-parts";

    niri-flake = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      systems,
      flake-parts,
      niri-flake,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } (
      {
        config,
        ...
      }@top:
      {
        imports = [ ];
        systems = import systems;
        flake = {
          homeModules.default =
            {
              config,
              lib,
              pkgs,
              ...
            }:
            {
              options.user.gui = with lib; {
                enable = mkEnableOption "GUI";
              };

              imports = [
                inputs.niri-flake.homeModules.stylix
                inputs.niri-flake.homeModules.niri

                ./de.nix
                ./bar.nix
              ];

              config = {
                services.swaync.enable = true;
                services.swayosd.enable = true;

                programs.fuzzel.enable = true;
                programs.swaylock.enable = true;
              };
            };
        };
      }
    );
}
