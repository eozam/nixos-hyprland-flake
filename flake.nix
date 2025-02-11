{
  description = "NixOS configuration";

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    {
      self,
      nixpkgs-stable,
      nixpkgs-unstable,
    }:
    {
      nixosConfigurations = {
        nixos = nixpkgs-stable.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hardware-configuration.nix
            ./configuration.nix
            (
              { config, pkgs, ... }:
              {
                nixpkgs.overlays = [
                  (final: prev: {
                    unstable = import nixpkgs-unstable {
                      inherit (prev) system;
                      config.allowUnfree = config.nixpkgs.config.allowUnfree;
                    };
                  })
                ];
              }
            )
          ];
        };
      };
    };
}
