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
    { self, nixpkgs, home-manager, ... }@inputs:
    let
      inherit (self) outputs;
      forAllSystems = nixpkgs.lib.genAttrs [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
      ];
    in
    {
      # Your custom packages
      # Acessible through 'nix build', 'nix shell', etc
      packages = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in import ./pkgs { inherit pkgs; }
      );
      # Devshell for bootstrapping
      # Acessible through 'nix develop' or 'nix-shell' (legacy)
      devShells = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in import ./shell.nix { inherit pkgs; }
      );
      # Your custom packages and modifications, exported as overlays
      overlays = import ./modules/overlays { inherit inputs; };
      # Reusable nixos modules you might want to export
      # These are usually stuff you would upstream into nixpkgs
      nixosModules = import ./modules/nixos;
      # Reusable home-manager modules you might want to export
      # These are usually stuff you would upstream into home-manager
      homeManagerModules = import ./modules/home;

      nixosConfigurations = {
        medion = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./hosts/medion/configuration.nix
            ./noconfig/user.nix
            home-manager.nixosModules.home-manager
            {
              pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
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
