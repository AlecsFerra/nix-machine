{ pkgs, lib, config, ... }:
with lib;
let 
  vimDirections = [
    { key = "l"; shortDir = "r"; resize = "10 0"; }
    { key = "h"; shortDir = "l"; resize = "-10 0"; }
    { key = "k"; shortDir = "u"; resize = "0 -10"; }
    { key = "j"; shortDir = "d"; resize = "0 10"; }
  ];
  cfg = config.wayland.windowManager;
  hyperlandPackage = cfg.hyprland.package;
in {
  config = mkIf cfg.hyprland.enable {

    # If someaone uses sway idle we force to use the correct hyprland
    # session target
    systemd.user.services.swayidle.Install.WantedBy = 
      lib.mkForce ["hyprland-session.target"];

    wayland = {
      lock.dpms = {
        on = pkgs.writeShellScriptBin "hyprland-dpms-on"
          "${getBin hyperlandPackage}/bin/hyprctl dispatch dpms on";
        off = pkgs.writeShellScriptBin "hyprland-dpms-off"
          "${getBin hyperlandPackage}/bin/hyprctl dispatch dpms off";
      };

      statusbar = {
        workspaces =  {
          number = 10;
          occupied = pkgs.writeShellScriptBin "hyprland-occupied"
            ''
              ${getBin hyperlandPackage}/bin/hyprctl workspaces \
              | grep 'workspace' \
              | grep -oP '\(\K[^)]+'
            '';
          active = 
            pkgs.writeShellScriptBin "hyprland-active"
              ''
                ${getBin hyperlandPackage}/bin/hyprctl monitors \
                | grep 'active workspace' \
                | grep -oP '\(\K[^)]+'
              '';
          goto = 
            pkgs.writeShellScriptBin "hyprland-goto"
              ''
                ${getBin hyperlandPackage}/bin/hyprctl dispatch workspace "$1"
              '';
          listen = 
            pkgs.writeShellScriptBin "hyprland-listen"
              ''
                tail -f /tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/hyprland.log
              '';
        };
      };
    };

    wayland.windowManager.hyprland = {
      settings = {
        input = {
          kb_layout = "it";
          kb_options = "caps:swapescape";
          touchpad = {
            natural_scroll = true;
          };
        };
        
        gestures = {
          workspace_swipe = true;
          workspace_swipe_forever = true;
        };

        monitor = [
          "DP-1, 1920x1080@60, 0x0, 0.5"
          ", preferred, auto, 1"
        ];

        general.layout = "master";

        misc = {
          vrr = true;
          mouse_move_enables_dpms = true;
          key_press_enables_dpms = false;
          enable_swallow = true;
          swallow_regex = "^(Alacritty|kitty|footclient)$";
        };

        "$mod" = "SUPER";
        bind = [
          "$mod, Q, killactive"
          "$mod, F, fullscreen"

          "$mod, x, exec, ${getExe cfg.lock}"

          "$mod, Return, exec, ${getExe cfg.terminal}"
          "$mod, d,      exec, ${getExe cfg.runner}"
        ]
        # Move focus
        ++ (builtins.map
          (it: "$mod, ${it.key}, movefocus, ${it.shortDir}")
          vimDirections
        )
        # Move window
        ++ (builtins.map
          (it: "$mod SHIFT, ${it.key}, movewindow, ${it.shortDir}")
          vimDirections
        )
        # Switch to workspace
        ++ (builtins.genList
          (it: let
            key = builtins.toString it;
            ws_no = builtins.toString (if it == 0 then 10 else it);
            in "$mod, ${key}, workspace, ${ws_no}")
          10
        )
        # Move workspace
        ++ (builtins.genList
          (it: let
            key = builtins.toString it;
            ws_no = builtins.toString (if it == 0 then 10 else it);
            in "$mod SHIFT, ${key}, movetoworkspace, ${ws_no}")
          10
        );

        # Repeated keybindings
        binde = [
          # Audio
          ", XF86AudioRaiseVolume, exec, ${getExe cfg.audio.increase}"
          ", XF86AudioLowerVolume, exec, ${getExe cfg.audio.decrease}"
          ", XF86AudioMute,        exec, ${getExe cfg.audio.mute}"
          ", XF86AudioMicMute,     exec, ${getExe cfg.audio.muteMic}"

          # Brighness
          ", XF86MonBrightnessDown, exec, ${getExe cfg.brightness.decrease}"
          ", XF86MonBrightnessUp,   exec, ${getExe cfg.brightness.increase}"
        ];

        # Risotto
        general = {
          gaps_out = 7;
          gaps_in = 5;
          cursor_inactive_timeout = 5;
        };

        animations = {
          enabled = true;
          animation = [
            "border, 1, 2, default"
            "fade, 1, 4, default"
            "windows, 1, 3, default, popin 80%"
            "workspaces, 1, 2, default, slide"
          ];
        };

        decoration = {
          rounding = 5;
            blur = {
            enabled = true;
            size = 10;
            passes = 3;
            new_optimizations = true;
            brightness = 1.0;
            contrast = 1.0;
            noise = 0.02;
          };

          drop_shadow = true;
          shadow_ignore_window = true;
          shadow_offset = "0 2";
          shadow_range = 20;
          shadow_render_power = 3;
        };
      };

      extraConfig = ''
        bind = $mod, R, submap, resize
        submap = resize
        '' +
        (builtins.concatStringsSep 
          "\n"
          (builtins.map
            (it: "binde = , ${it.key}, resizeactive, ${it.resize}")
            vimDirections
          )
        )
        + "\n" + ''
        bind = , escape, submap, reset
        submap = reset

        # Passtrough
        bind = CTRL , Alt_L, submap, passthrough
        submap = passthrough
        bind = CTRL , Alt_L, submap, reset
        submap = reset
      '';
    };
  };
}
