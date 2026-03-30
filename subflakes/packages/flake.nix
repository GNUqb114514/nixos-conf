{
  description = "My simple system configuration - Packages";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    systems = {
      url = "github:nix-systems/default";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };
  };

  outputs = { nixpkgs, systems, flake-parts, ... }@inputs: flake-parts.lib.mkFlake { inherit inputs; } ({
    config, withSystem, moduleWithSystem, ...
  }@top: {
    imports = [ ];
    perSystem = { config, self', inputs', pkgs, system, ... }: {
      packages = import ./default.nix { inherit pkgs; };
    };
    systems = import systems;
  });
}
