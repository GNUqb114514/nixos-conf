{
  description = "My simple system configuration - Basic home configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";

    systems.url = "github:nix-systems/default";

    flake-parts.url = "github:hercules-ci/flake-parts";

    stylix = {
      url = "github:danth/stylix";
      inputs.flake-parts.follows = "flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
    };

    xremap = {
      url = "github:xremap/nix-flake";
      inputs.flake-parts.follows = "flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    packages = {
      url = "../../packages";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
      inputs.flake-parts.follows = "flake-parts";
    };
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
        withSystem,
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
              options.user = with lib; {
                inputs = mkOption {
                  description = "Inputs of my home-manager flake.";
                  internal = true;
                  readOnly = true;
                };
                inputs' = mkOption {
                  description = "Inputs of my home-manager flake with system information pre-applied.";
                  internal = true;
                  readOnly = true;
                };
              };

              imports = [
                inputs.stylix.homeModules.stylix
                inputs.xremap.homeManagerModules.default

                ./stylix.nix
                ./im.nix
                ./shell.nix
                ./terminal.nix
                ./qutebrowser.nix
                ./ssh.nix
                ./helix.nix
                ./xremap.nix
                ./bluetooth.nix
                ./direnv.nix
              ];

              config = {
                user.inputs = inputs;
                user.inputs' = withSystem pkgs.stdenv.hostPlatform.system ({ inputs', ... }: inputs');
              };
            };
        };
      }
    );
}
