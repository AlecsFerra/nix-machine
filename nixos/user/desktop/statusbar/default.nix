{ lib, ... }:
with lib;
{
  options.wayland.statusbar = {
    eww.enable = mkEnableOption "Enable the eww statusbar";

    workspacesNumber = mkOption {
      type = types.int;
      description = "The total number of workspaces";
    };

    workspaces = {
      active = mkOption {
        type = types.package;
        description = 
          "Command that returns the current active workspaces";
      };

      existing = mkOption {
        type = types.package;
        description = 
          "Command that returns a new-line separated list of active workspaces";
      };

      goto = mkOption {
        type = types.package;
        description = "Command that switchs to the wokspace passed as argument";
      };
    };
  };

  imports = [ ./eww ];
}
