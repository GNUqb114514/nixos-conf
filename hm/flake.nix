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

    crane = {
      url = "github:ipetkov/crane";
    };

    niri-flake = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.flake-parts.follows = "flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
    };

    # agenix = {
    #   url = "github:ryantm/agenix";
    #   inputs.darwin.follows = "";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    xremap = {
      url = "github:xremap/nix-flake";
      inputs.flake-parts.follows = "flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.crane.follows = "crane";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    maple-font = {
      url = "github:subframe7536/maple-font";
      flake = false;
    };

    org-hold = {
      url = "github:GNUqb114514/org-hold";
      flake = false;
    };

    stasis = {
      url = "github:saltnpepper97/stasis";
      inputs.flake-parts.follows = "flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neomacs = {
      url = "github:eval-exec/neomacs/v0.0.2";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.crane.follows = "crane";
      inputs.rust-overlay.follows = "rust-overlay";
    };

    emacsConfig = {
      url = "./emacs";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
      inputs.flake-parts.follows = "flake-parts";
    };

    guiConfig = {
      url = "./gui";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
      inputs.flake-parts.follows = "flake-parts";
    };

    nvimConfig = {
      url = "./nvim";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
      inputs.flake-parts.follows = "flake-parts";
    };

    basicConfig = {
      url = "./basic";
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
      stasis,
      neomacs,
      packages,
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
                inputs.niri-flake.homeModules.stylix
                inputs.niri-flake.homeModules.niri
                inputs.stylix.homeModules.stylix
                inputs.xremap.homeManagerModules.default
                inputs.stasis.homeModules.default
                inputs.emacsConfig.homeModules.default
                inputs.guiConfig.homeModules.default
                inputs.nvimConfig.homeModules.default
                inputs.basicConfig.homeModules.default
                # ./modules/default.nix
              ];
            };
        };
        systems = import systems;
      }
    );
}
