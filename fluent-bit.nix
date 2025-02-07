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
        name                 opentelemetry
        match                * 
        host                 127.0.0.1
        port                 4318
        header               Content-Type application/json
        metrics_uri          /v1/metrics
        logs_uri             /v1/logs
        traces_uri           /v1/traces
        Log_response_payload True
        tls                  off
        tls.verify           off

        # add user-defined labels
        add_label            app fluent-bit
        add_label            color blue
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
