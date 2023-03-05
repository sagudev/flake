{ lib, pkgs, ... }:

{
  config = {
    home-manager.users.samo = ./home.nix;
    users.users.samo = {
      isNormalUser = true;
      home = "/home/samo";
      createHome = true;
      passwordFile = "/persist/encrypted-passwords/samo";
      extraGroups = [ "wheel" "disk" "networkmanager" "libvirtd" "qemu-libvirtd" "kvm" "i2c" "plugdev" ];
    };
  };
}
