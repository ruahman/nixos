{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.fluent-bit;
  
  # config file for fluent-bit
  configFile = pkgs.writeText "fluent-bit.conf" ''
    [INPUT]
        name           tail
        path           /home/ruahman/source/velas/bitscaler/packages/transaction-manager/logs/transaction_manager.log
        tag            transaction_manager
        read_from_head true
        parser         json
    
    [OUTPUT]
        name         opentelemetry
        match        transaction_manager
        host         127.0.0.1
        port         4317
        tls          off
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
