{
  system ? builtins.currentSystem,
  hostname ? builtins.readFile "/etc/hostname",
}:

let
  # Remove any trailing newlines from hostname
  cleanHostname = builtins.replaceStrings [ "\n" ] [ "" ] hostname;

  # Common user attributes
  commonAttrs = {
    name = "aimestereo";
    hostname = cleanHostname;
  };

  # Define user configurations for different devices
  userConfigs = {
    "macOS" = {
      # Good for both macbook air and M3 pro
      system = "aarch64-darwin";
      homeDir = "/Users/aimestereo";
    } // commonAttrs;

    "main" = {
      system = "x86_64-linux";
      homeDir = "/home/aimestereo";
    } // commonAttrs;
  };
in
userConfigs
