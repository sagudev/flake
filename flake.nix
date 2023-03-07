{
  description = "Nix's Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs-mozilla.url = "github:mozilla/nixpkgs-mozilla";

    # Devshell inputs
    mission-control.url = "github:Platonic-Systems/mission-control";
    #mission-control.inputs.nixpkgs.follows = "nixpkgs";
    flake-root.url = "github:srid/flake-root";

    #TODO: agenix
    #TODO: cache
  };

  outputs = inputs@{ self, home-manager, nixpkgs, nixos-wsl, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      # systems for which you want to build the `perSystem` attributes
      systems = [ "x86_64-linux" ];
      imports = [
        inputs.flake-root.flakeModule
        inputs.mission-control.flakeModule
        ./lib.nix
        ./users
        ./home
        #./modules
      ];

      flake = {
        # Configurations for Linux (NixOS) systems
        nixosConfigurations = {
          pce = self.lib.mkLinuxSystem {
            imports = [
              self.nixosModules.default # Defined in nixos/default.nix
              ./systems/hetzner/ax101.nix
              ./nixos/server/harden.nix
              ./nixos/docker.nix
            ];
          };
        };
      };

      perSystem = { pkgs, config, inputs', ... }: {
        devShells.default = config.mission-control.installToDevShell (pkgs.mkShell {
          buildInputs = [
            pkgs.nixpkgs-fmt
            #inputs'.agenix.packages.agenix
          ];
        });
        formatter = pkgs.nixpkgs-fmt;
      };

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

    };
}
