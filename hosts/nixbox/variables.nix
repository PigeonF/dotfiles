{ config, lib, ... }:
{
  options.nixbox =
    let
      inherit (config.services.dockerRegistry) listenAddress port;
    in
    {
      registryHost = lib.mkOption {
        type = lib.types.str;
        default = "${listenAddress}${lib.optionalString (port != 443) ":${toString port}"}";
        description = "Combined listen address from the config.services.dockerRegistry";
      };
    };
}
