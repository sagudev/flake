{ lib, pkgs, home-manager, ... }:

{
  #home-manager.useGlobalPkgs = true;
  #useUserPackages = true;
  #users.samo = import ./home.nix;
  users.users.samo = {
    isNormalUser = true;
    home = "/home/samo";
    createHome = true;
    description = "samo";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    # user packages
    #packages = with pkgs; [
    #  thunderbird
    #];
    #extraGroups = [ "wheel" "disk" "networkmanager" "libvirtd" "qemu-libvirtd" "kvm" "i2c" "plugdev" ];
  };

}
