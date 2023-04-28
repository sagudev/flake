/*
  A trait for all boxxen
*/
{ config, pkgs, lib, ... }:

{
  config = {
    nixpkgs.config.allowUnfree = true;

    # Use edge Nix.
    nix.settings.experimental-features = [ "nix-command" "flakes" "repl-flake" ];
  };
}
