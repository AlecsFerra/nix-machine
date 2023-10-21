{ pkgs, ... }:
let vimDirections = [
  { key = "l"; shortDir = "r"; resize = "+10 0"; }
  { key = "h"; shortDir = "l"; resize = "-10 0"; }
  { key = "k"; shortDir = "u"; resize = "0   -10"; }
  { key = "j"; shortDir = "d"; resize = "0   +10"; }
];
in {
  wayland.windowManager.hyprland = {
    enable = true;
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

      misc = {
        vrr = true;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
        enable_swallow = true;
      };

      "$mod" = "SUPER";
      bind = [
        "$mod, Q, killactive"
        "$mod, F, fullscreen"

        "$mod, Return, exec, alacritty"
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

      # Risotto
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
        rounding = 16;
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
        "col.shadow" = "rgba(00000055)";
      };
    };
  };
}