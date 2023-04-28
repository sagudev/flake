/*
  A trait for all boxxen
*/
{ config, pkgs, lib, ... }:

{
  config = {
    # System packages
    environment.systemPackages = with pkgs; [
      # Stuff you always need
      direnv
      nix-direnv
      git
      wget
      curl
      nano
      htop
      ntfs3g
      # gptfdisk
    ];

    # home manager
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;

    nixpkgs.config.allowUnfree = true;

    # Use edge NixOS.
    nix.settings.experimental-features = [ "nix-command" "flakes" "repl-flake" ];
    system.autoUpgrade.enable = true;

    # Hack: https://github.com/NixOS/nixpkgs/issues/180175
    systemd.services.systemd-udevd.restartIfChanged = false;
  };
}
