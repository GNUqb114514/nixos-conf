{ pkgs, config, inputs, ...}: let system = "x86_64-linux"; in {
  config = {
    environment.systemPackages = [
      inputs.agenix.packages.${system}.default
    ];

    home-manager = {
      extraSpecialArgs = {
        inherit (config.age) secrets;
      };
      users.qb114514 = import ../users/qb114514.nix;
    };

    networking.hostName = "laptop";

    nixpkgs.overlays = [
      inputs.rust-overlay.overlays.default
    ];
  };
  
  imports = [
    ../age.nix

    ./common.nix
  ];
}
