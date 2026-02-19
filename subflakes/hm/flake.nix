{
  description = "My simple system configuration - Home setup";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";

    niri-flake = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix.url = "github:danth/stylix";

    nvf = {
      url = "github:notashelf/nvf";
      # You can override the input nixpkgs to follow your system's
      # instance of nixpkgs. This is safe to do as nvf does not depend
      # on a binary cache.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.darwin.follows = "";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nerdicons-nvim = {
      url = "github:nvimdev/nerdicons.nvim";
      flake = false;
    };

    vim-barbaric = {
      url = "github:rlue/vim-barbaric";
      flake = false;
    };

    xremap.url = "github:xremap/nix-flake";

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

  outputs = {
    nixpkgs, home-manager, ...
  }@inputs: {
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
