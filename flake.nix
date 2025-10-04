{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ nixpkgs, home-manager, ... }: {

	nixosConfigurations.nixos-anhnt = nixpkgs.lib.nixosSystem {
		modules = [
		  ./configuration.nix
		  home-manager.nixosModules.home-manager
		  {
		    home-manager.useGlobalPkgs = true;
		    home-manager.useUserPackages = true;
		    home-manager.users.anhnt = ./home.nix;

		    # Optionally, use home-manager.extraSpecialArgs to pass
		    # arguments to home.nix
		  }
		];
	};

  };
}
