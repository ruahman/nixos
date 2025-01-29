{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.fluent-bit;
  
  # config file for fluent-bit
  configFile = pkgs.writeText "fluent-bit.conf" ''
    [INPUT]
        Name         cpu
        Interval_Sec 1

    [OUTPUT]
        Name         stdout
        Match        *
  '';
in {

  options.services.fluent-bit = {
    enable = mkEnableOption "Fluent Bit log processor";
  };

  config = mkIf cfg.enable {
    systemd.services.fluent-bit = {
      description = "Fluent Bit log processor";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        ExecStart = "${pkgs.fluent-bit}/bin/fluent-bit -c ${configFile}";
        Restart = "always";
        RestartSec = "5s";
      };
    };
  };
}
