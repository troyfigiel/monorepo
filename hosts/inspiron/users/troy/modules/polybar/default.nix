{ pkgs, ... }:

let
  ac = "#1E88E5";
  mf = "#383838";

  bg = "#11121D";
  fg = "#FFFFFF";

  # Colored
  primary = "#91ddff";

  # Dark
  secondary = "#141228";

  # Colored (light)
  tertiary = "#65b2ff";

  # white
  quaternary = "#ecf0f1";

  # middle gray
  quinternary = "#20203d";

  # Red
  urgency = "#e74c3c";

  offset = "3";

in {
  services.polybar = {
    enable = true;

    package = pkgs.polybar.override {
      i3GapsSupport = true;
      alsaSupport = true;
      mpdSupport = true;
    };

    script = "polybar -q -r bottom &";

    config = {
      "global/wm" = {
        margin-bottom = 0;
        margin-top = 0;
      };

      "bar/bottom" = {
        bottom = true;

        width = "100%";

        background = bg;
        foreground = fg;

        tray-position = "left";
        tray-background = bg;

        font-0 = "Inconsolata:size=16;${offset}";
        font-1 = "Font Awesome 6 Free,Font Awesome 6 Free Solid:style=Solid;${offset}";

        modules-left = "i3 audio";
        modules-center = "cpu memory battery";
        modules-right = "date wlan powermenu";

        locale = "en_US.UTF-8";
      };

      "module/audio" = {
        type = "internal/alsa";

        format-volume = "VOL <label-volume>";
        format-volume-padding = 1;
        format-volume-foreground = secondary;
        format-volume-background = tertiary;
        label-volume = "%percentage%%";

        format-muted = "<label-muted>";
        format-muted-padding = 1;
        format-muted-foreground = secondary;
        format-muted-background = tertiary;
        format-muted-prefix-foreground = urgency;
        format-muted-overline = bg;

        label-muted = "VOL Muted";
      };

      "module/battery" = {
        type = "internal/battery";
        full-at = 99; # to disable it
        battery = "BAT0"; # TODO: Better way to fill this
        adapter = "AC0";

        poll-interval = 2;

        label-full = " 100%";
        format-full-padding = 1;
        format-full-foreground = secondary;
        format-full-background = primary;

        format-charging = " <animation-charging> <label-charging>";
        format-charging-padding = 1;
        format-charging-foreground = secondary;
        format-charging-background = primary;
        label-charging = "%percentage%%";
        animation-charging-0 = "";
        animation-charging-1 = "";
        animation-charging-2 = "";
        animation-charging-3 = "";
        animation-charging-4 = "";
        animation-charging-framerate = 500;

        format-discharging = "<ramp-capacity> <label-discharging>";
        format-discharging-padding = 1;
        format-discharging-foreground = secondary;
        format-discharging-background = primary;
        # On click time left should be shown
        label-discharging = "%percentage%%";# %time%";
        ramp-capacity-0 = "";
        ramp-capacity-0-foreground = urgency;
        ramp-capacity-1 = "";
        ramp-capacity-1-foreground = urgency;
        ramp-capacity-2 = "";
        ramp-capacity-3 = "";
        ramp-capacity-4 = "";
      };

      "module/cpu" = {
        type = "internal/cpu";

        interval = 1;

        format = " <label>";
        format-foreground = quaternary;
        format-background = secondary;
        format-padding = 1;

        label = "%percentage-sum%%";
      };

      "module/date" = {
        type = "internal/date";

        interval = "1";

        time = "%a, %b %d, %Y at %H:%M";

        format = "<label>";
        format-padding = 1;
        format-foreground = fg;

        label = "%time%";
      };

      "module/i3" = {
        type = "internal/i3";

        label-mode = "%mode%";
        label-mode-padding = 1;

        label-unfocused = "%icon%";
        label-unfocused-foreground = quinternary;
        label-unfocused-padding = 1;

        label-focused = "%index% %icon%";
        label-focused-foreground = secondary;
        label-focused-padding = 1;

        label-visible = "%icon%";
        label-visible-padding = 1;

        label-urgent = "%index%";
        label-urgent-foreground = urgency;
        label-urgent-padding = 1;
      };

      "module/title" = {
        type = "internal/xwindow";
        format = "<label>";
        format-foreground = secondary;
        label = "%title%";
        label-maxlen = 70;
      };

      "module/memory" = {
        type = "internal/memory";

        interval = 3;

        format = " <label>";
        format-background = tertiary;
        format-foreground = secondary;
        format-padding = 1;

        label = "%used%";
      };

      "module/wlan" = {
        type = "internal/network";
        interface = "wlan0";
        interval = 1;

        format-connected = "<label-connected>";
        format-connected-padding = 1;
        label-connected = "%{A1:wifimenu:} %essid%%{A}";
        label-connected-foreground = fg;
        label-connected-padding = 1;

        format-disconnected = "<label-disconnected>";
        format-disconnected-padding = 1;
        label-disconnected = "%{A1:wifimenu:}%{A}";
        label-disconnected-foreground = fg;
        label-disconnected-padding = 1;
      };

      "module/temperature" = {
        type = "internal/temperature";

        interval = 1;

        thermal-zone = 0; # TODO: Find a better way to fill that
        warn-temperature = 60;
        units = true;

        format = "<label>";
        format-background = mf;
        format-underline = bg;
        format-overline = bg;
        format-padding = 2;
        format-margin = 0;

        format-warn = "<label-warn>";
        format-warn-background = mf;
        format-warn-underline = bg;
        format-warn-overline = bg;
        format-warn-padding = 2;
        format-warn-margin = 0;

        label = "TEMP %temperature-c%";
        label-warn = "TEMP %temperature-c%";
        label-warn-foreground = "#f00";
      };
    };
  };
}
