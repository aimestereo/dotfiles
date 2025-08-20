{ system ? builtins.currentSystem, hostname ? builtins.readFile "/etc/hostname" }:

let
  # Remove any trailing newlines from hostname
  cleanHostname = builtins.replaceStrings ["\n"] [""] hostname;

  # Common user attributes
  commonAttrs = {
    name = "aimestereo";
  };

  # Host-specific configurations
  hostConfigs = {
    "aimestereo-Air" = {
      system = "aarch64-darwin";
      homeDir = "/Users/aimestereo";
    };

    "aimestereo-arch" = {
      system = "x86_64-linux";
      homeDir = "/home/aimestereo";
    };
  };

  # Get the config for the current host or use a default
  hostConfig = hostConfigs.${cleanHostname} or (
    if builtins.match ".*darwin.*" system != null then
      hostConfigs."aimestereo-Air"
    else
      hostConfigs."aimestereo-arch"
  );
in
commonAttrs // hostConfig // { hostname = cleanHostname; }
