{ lib, pkgs, ... }:

{
  config = {
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.jdoe = samo ./home.nix;
    }
    # home-manager.users.samo = ./home.nix;
    /*users.users.samo = {
      isNormalUser = true;
      home = "/home/samo";
      createHome = true;
      description = "samo";
      extraGroups = [ "networkmanager" "wheel" "docker" ];
      # user packages
      packages = with pkgs; [
        thunderbird
      ];
      #extraGroups = [ "wheel" "disk" "networkmanager" "libvirtd" "qemu-libvirtd" "kvm" "i2c" "plugdev" ];
    };*/
  };
}
