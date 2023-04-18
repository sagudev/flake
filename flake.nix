{
  description = "Nix's Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs-mozilla.url = "github:mozilla/nixpkgs-mozilla";

    #TODO: agenix for secrets
    #TODO: cache
  };

  outputs = { home-manager, nixpkgs, ... }:
    {
      # nixos-wsl
      nixosConfigurations.nixos-wsl = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/nixos-wsl/configuration.nix
          ./home/default.nix
        ];
      };
      nixosConfigurations.medion = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/medion/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.samo = import ./home.nix;
          }
        ];
      };
    };


  /*outputs = { self, home-manager, nixpkgs, nixos-wsl, ... }@inputs:
        let
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
      ];

      legacyPackages = forAllSystems (system:
        import nixpkgs {
          inherit system;
          config = { allowUnfree = true; };
          overlays = with inputs; [
            nur.overlay
            emacs.overlay
          ];
        });

      mkHost = nixpkgs.lib.nixosSystem;
      mkHome = home-manager.lib.homeManagerConfiguration;
        in
        {
      homeManagerModules = import ./modules/home-manager;
      nixosModules = import ./modules/host;

      devShells = forAllSystems (system: {
        default = import ./shell.nix { pkgs = legacyPackages.${system}; };
      });

      formatter = forAllSystems (system: legacyPackages.${system}.nixpkgs-fmt);

      nixosConfigurations."beepboop" = mkHost {
        pkgs = legacyPackages.x86_64-linux;
        modules = [ ./hosts/beepboop.nix ];
        specialArgs = { inherit self inputs; };
      };

      homeConfigurations."beepboop" = mkHome {
        pkgs = self.outputs.nixosConfigurations.beepboop.pkgs;
        modules = [ ./home/beepboop.nix ];
        extraSpecialArgs = { inherit self inputs; };
      };
      };*/

  /*let
      inherit (self) outputs;
      forAllSystems = nixpkgs.lib.genAttrs [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
      ];
        in
        rec {
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
      overlays = import ./overlays { inherit inputs; };
      # Reusable nixos modules you might want to export
      # These are usually stuff you would upstream into nixpkgs
      nixosModules = import ./modules/nixos;
      # Reusable home-manager modules you might want to export
      # These are usually stuff you would upstream into home-manager
      homeManagerModules = import ./modules/home-manager;

      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {
        MEDION = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [

            ./host/medion.nix
          ];
        };
        wsl = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [

            ./host/wsl.nix
          ];
        };
      };

      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake .#your-username@your-hostname'
      homeConfigurations = {
        # FIXME replace with your username@hostname
        "samo@MEDION" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            # > Our main home-manager configuration file <
            ./home-manager/home.nix
          ];
        };
      };*/
  /*{
        # medion laptop
        nixosConfigurations.medion = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = with self.nixosModules; [
        host.medion
      ];
        };
        # wsl
        nixosConfigurations.wsl = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = with self.nixosModules; [
        nixos-wsl.nixosModules.wsl
        host.wsl
        users.samo
      ];
        };

        nixosModules = {
      host.container = ./host/container.nix;
      host.wsl = ./host/wsl.nix;
      host.medion = ./host/medion.nix;
      traits.overlay = { nixpkgs.overlays = [ self.overlays.default ]; };
      traits.base = ./traits/base.nix;
      traits.machine = ./traits/machine.nix;
      traits.wine = ./traits/wine.nix;
      traits.gnome = ./traits/gnome.nix;
      traits.sourceBuild = ./traits/source-build.nix;
      # This trait is unfriendly to being bundled with platform-iso
      traits.workstation = ./traits/workstation.nix;
      users.samo = ./users/samo;
      };*/

  #formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;

  /*homeConfigurations.samo = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          overlays = [ self.overlays.default ];
          config.allowUnfree = true;
        };
        modules = [
          ./users/samo/home.nix
        ];
      };

      nixosConfigurations =
        let
          # Shared config between both the liveimage and real system
          Base_x64 = {
            system = "x86_64-linux";
            modules = with self.nixosModules; [
              ({ config = { nix.registry.nixpkgs.flake = nixpkgs; }; })
              home-manager.nixosModules.home-manager
              traits.overlay
              traits.base
            ];
          };
        in
        with self.nixosModules; {
          IsoImage = nixpkgs.lib.nixosSystem {
            inherit (Base_x64) system;
            modules = Base_x64.modules ++ [
              platforms.iso
            ];
          };
          medion = nixpkgs.lib.nixosSystem {
            inherit (Base_x64) system;
            modules = Base_x64.modules ++ [
              platforms.medion
              traits.machine
              traits.workstation
              traits.gnome
              users.samo
            ];
          };
          wsl = nixpkgs.lib.nixosSystem {
            inherit (Base_x64) system;
            modules = Base_x64.modules ++ [
              nixos-wsl.nixosModules.wsl
              platforms.wsl
              users.samo
            ];
          };
        };

      nixosModules = {
        platforms.container = ./platforms/container.nix;
        platforms.wsl = ./platforms/wsl.nix;
        platforms.medion = ./platforms/medion.nix;
        platforms.iso-minimal = "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix";
        platforms.iso = "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-gnome.nix";
        traits.overlay = { nixpkgs.overlays = [ self.overlays.default ]; };
        traits.base = ./traits/base.nix;
        traits.machine = ./traits/machine.nix;
        traits.wine = ./traits/wine.nix;
        traits.gnome = ./traits/gnome.nix;
        traits.sourceBuild = ./traits/source-build.nix;
        # This trait is unfriendly to being bundled with platform-iso
        traits.workstation = ./traits/workstation.nix;
        users.samo = ./users/samo;
      };

      checks = {
        format = pkgs.runCommand "check-format"
        {
          buildInputs = with pkgs; [ rustfmt cargo ];
        } ''
          ${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt --check ${./.}
          touch $out # it worked!
          '';
      };*/

  # };
}
