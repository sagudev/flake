{
  description = "Nix's Flake";

  inputs = {
    #nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-22.11";
    # Who is scared?
    # Me not.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    #flake-utils.url = "github:numtide/flake-utils";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixpkgs-mozilla.url = "github:mozilla/nixpkgs-mozilla";

    nur.url = "github:nix-community/NUR";
    # My own NUR repo for bleeding-edge updates
    #nur-ifd3f = {
    #  url = "github:ifd3f/nur-packages";
    #  inputs.nixpkgs.follows = "nixpkgs-unstable";
    #};

    #nixos-generators

    #TODO: agenix for secrets
    #TODO: cache
  };

  outputs =
    { self, nixpkgs, home-manager, ... }@attrs: {
      nixosConfigurations = {
        medion = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = attrs;
          modules = [
            ./hosts/medion/configuration.nix
            ./noconfig/user.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.samo = import ./noconfig/home/home.nix;
            }

          ];
        };
        #wsl = nixpkgs.lib.nixosSystem {
        #  system = "x86_64-linux";
        #  modules = [
        #    ({ config, pkgs, ... }: { nix.registry.nixpkgs.flake = nixpkgs; })
        #    ./hosts
        #    ./hosts/Moby.nix
        #  ];
        #};
      };
    };
}
