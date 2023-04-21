/*
  A trait for all boxxen
*/
{ ... }:

{
  config = {
    # Set your time zone.
    time.timeZone = "Europe/Ljubljana";

    # Select internationalisation properties.
    i18n.defaultLocale = "sl_SI.UTF-8";
    i18n.supportedLocales = [ "all" ];
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "sl_SI.UTF-8";
      LC_IDENTIFICATION = "sl_SI.UTF-8";
      LC_MEASUREMENT = "sl_SI.UTF-8";
      LC_MONETARY = "sl_SI.UTF-8";
      LC_NAME = "sl_SI.UTF-8";
      LC_NUMERIC = "sl_SI.UTF-8";
      LC_PAPER = "sl_SI.UTF-8";
      LC_TELEPHONE = "sl_SI.UTF-8";
      LC_TIME = "sl_SI.UTF-8";
    };
  };
}
