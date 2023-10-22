{ lib, ... }:
with lib;
{
  options.wayland.statusbar = {
    eww.enable = mkEnableOption "Enable the eww statusbar";

    workspaces = {
      
      number = mkOption {
        type = types.int;
        description = "The total number of workspaces";
      };

      active = mkOption {
        type = types.package;
        description = 
          "Command that returns the current active workspaces";
      };

      occupied = mkOption {
        type = types.package;
        description = 
          "Command that returns a new-line separated list of occupied workspaces";
      };

      goto = mkOption {
        type = types.package;
        description = "Command that switchs to the wokspace passed as argument";
      };

      listen = mkOption {
        type = types.package;
        description = 
          "Command that returns a new-line each time the workspaces are updated";
      };
    };
  };

  imports = [ ./eww ];
}
