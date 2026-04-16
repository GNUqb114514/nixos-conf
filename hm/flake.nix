{
  description = "My simple system configuration - Home setup";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";

    systems = {
      url = "github:nix-systems/default";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacsConfig = {
      url = "./emacs";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
      inputs.flake-parts.follows = "flake-parts";
      inputs.packages.follows = "packages";
    };

    guiConfig = {
      url = "./gui";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
      inputs.flake-parts.follows = "flake-parts";
      inputs.packages.follows = "packages";
    };

    nvimConfig = {
      url = "./nvim";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
      inputs.flake-parts.follows = "flake-parts";
      inputs.packages.follows = "packages";
    };

    basicConfig = {
      url = "./basic";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
      inputs.flake-parts.follows = "flake-parts";
      inputs.packages.follows = "packages";
    };

    packages = {
      url = "./packages";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
      inputs.flake-parts.follows = "flake-parts";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      flake-parts,
      systems,
      emacsConfig,
      guiConfig,
      nvimConfig,
      basicConfig,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } (
      {
        config,
        withSystem,
        moduleWithSystem,
        ...
      }@top:
      {
        imports = [ ];
        flake = {
          homeModules.qb =
            { lib, pkgs, ... }:
            {
              imports = [
                inputs.emacsConfig.homeModules.default
                inputs.guiConfig.homeModules.default
                inputs.nvimConfig.homeModules.default
                inputs.basicConfig.homeModules.default
              ];
            };
        };
        systems = import systems;
      }
    );
}
