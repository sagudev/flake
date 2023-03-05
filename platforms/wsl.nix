{ pkgs, lib, ... }:

{
  config = {
    wsl.enable = true;
    wsl.defaultUser = "samo";
    i18n.supportedLocales = [ "all" ];
    i18n.defaultLocale = "en_CA.UTF-8";
  };
}
