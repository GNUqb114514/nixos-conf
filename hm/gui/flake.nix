{
  description = "My simple system configuration - GUI configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";

    systems.url = "github:nix-systems/default";

    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    {
      nixpkgs,
      systems,
      flake-parts,
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
