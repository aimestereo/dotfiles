# Pin nushell polars plugin to version 0.108.0: nushellPlugins.polars
# Issue: https://github.com/NixOS/nixpkgs/pull/467152

{ pkgs, ... }:
final: prev: {
  nushellPlugins = prev.nushellPlugins // {
    polars = prev.nushellPlugins.polars.overrideAttrs (oldAttrs: rec {
      version = "0.108.0";
      src = prev.fetchFromGitHub {
        owner = "nushell";
        repo = "nushell";
        rev = version;
        hash = "sha256-8OMTscMObV+IOSgOoTSzJvZTz6q/l2AjrOb9y3p2tZY=";
      };
      cargoDeps = oldAttrs.cargoDeps.overrideAttrs (
        prev.lib.const {
          inherit src;
          outputHash = "sha256-M2wkhhaS3bVhwaa3O0CUK5hL757qFObr7EDtBFXXwxg=";
        }
      );
    });
  };
}
