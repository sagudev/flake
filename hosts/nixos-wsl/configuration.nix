{ pkgs, lib, ... }:

{
  config = {
    wsl.enable = true;
    wsl.defaultUser = "samo";
    host.gui = false;
    host.virtual = true;
  };
}
