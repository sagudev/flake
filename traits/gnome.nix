/*
  A trait for headed boxxen
*/
{ config, pkgs, lib, ... }:

{
  config = {
    services.xserver.enable = true;
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.displayManager.autoLogin.enable = false;
    services.xserver.desktopManager.gnome.enable = true;
    environment.gnome.excludePackages = (with pkgs; [
      gnome-photos
      gnome-tour
    ]) ++ (with pkgs.gnome; [
      cheese # webcam tool
      gedit # text editor
      gnome-characters
      yelp # Help view
      gnome-contacts
      gnome-initial-setup
    ]);

    environment.systemPackages = with pkgs; [
      gnome.gnome-tweaks
      gnome.gnome-characters
    ];

    services.gnome.gnome-keyring.enable = true;

    programs.dconf.enable = true;
  };
}

