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

    nvf = {
      url = "github:notashelf/nvf";
      # You can override the input nixpkgs to follow your system's
      # instance of nixpkgs. This is safe to do as nvf does not depend
      # on a binary cache.
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
      inputs.systems.follows = "systems";
    };

    # agenix = {
    #   url = "github:ryantm/agenix";
    #   inputs.darwin.follows = "";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    nerdicons-nvim = {
      url = "github:nvimdev/nerdicons.nvim";
      flake = false;
    };

    vim-barbaric = {
      url = "github:rlue/vim-barbaric";
      flake = false;
    };

    xremap = {
      url = "github:xremap/nix-flake";
      inputs.flake-parts.follows = "flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
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
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    {
      homeModules.qb = {
        _module.args = inputs;
        imports = [
          inputs.niri-flake.homeModules.stylix
          inputs.niri-flake.homeModules.niri
          inputs.nvf.homeManagerModules.default
          inputs.stylix.homeModules.stylix
          inputs.xremap.homeManagerModules.default
          ./modules/default.nix
        ];
      };
    };
}
