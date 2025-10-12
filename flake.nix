{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zig.url = "github:mitchellh/zig-overlay";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      # Overlays is the list of overlays we want to apply from flake inputs.
      overlays = [
        inputs.zig.overlays.default
      ];

      mkSystem = import ./lib/mksystem.nix {
        inherit overlays nixpkgs inputs;
      };
    in
    {
      nixosConfigurations.vm-aarch64 = mkSystem "vm-aarch64" {
        system = "aarch64-linux";
        user = "anhnt";
      };

      nixosConfigurations.pc-intel = mkSystem "pc-intel" rec {
        system = "x86_64-linux";
        user = "anhnt";
      };
    };

  # outputs =
  #   inputs@{
  #     nixpkgs,
  #     rust-overlay,
  #     zig,
  #     home-manager,
  #     ...
  #   }:
  #   {
  #     nixosConfigurations.nixos-anhnt = nixpkgs.lib.nixosSystem {
  #       modules = [
  #         ./configuration.nix
  #         home-manager.nixosModules.home-manager
  #         (
  #           { pkgs, ... }:
  #           {
  #             nixpkgs.overlays = [
  #               rust-overlay.overlays.default
  #               zig.overlays.default
  #             ];
  #             environment.systemPackages = [ pkgs.rust-bin.stable.latest.default ];
  #           }
  #         )
  #         {
  #           home-manager.useGlobalPkgs = true;
  #           home-manager.useUserPackages = true;
  #           home-manager.users.anhnt = ./home.nix;
  #
  #           # Optionally, use home-manager.extraSpecialArgs to pass
  #           # arguments to home.nix
  #         }
  #       ];
  #     };
  #
  #   };
}
