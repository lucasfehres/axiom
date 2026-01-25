{ lib, ... }:

{
  options.host.ipv4 = lib.mkOption {
    type = lib.types.str;
    example = "10.67.1.121";
    description = "Primary IPv4 address. Recommended range is from 10.67.1.101 to 10.67.1.200";
  };
}
