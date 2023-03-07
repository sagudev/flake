{ pkgs, lib, ... }:

{
  config = {
    wsl.enable = true;
    wsl.defaultUser = "samo";
  };
}
