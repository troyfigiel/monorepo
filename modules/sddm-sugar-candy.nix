# TODO: What assertions should hold?
# TODO: Which descriptions need to be adjusted?
{ config, lib, pkgs, ... }:

with lib;
let cfg = config.services.xserver.displayManager.sddm.sugar-candy;
in {
  options.services.xserver.displayManager.sddm.sugar-candy = {

    enable = mkEnableOption "Sugar-candy theme";

    # TODO: Could we make this into a path to an image or pick from a set of defaults that come with the theme?
    background = mkOption {
      default = "Backgrounds/Mountain.jpg";
      type = types.str;
      description = ''
        Path relative to the theme root directory. Most standard image file formats are allowed including support for transparency. (e.g. background.jpeg/illustration.GIF/Foto.png/undraw.svgz)
      '';
    };

    dimBackgroundImage = mkOption {
      default = 0.0;
      type = types.float;
      description = ''
        Double between 0 and 1 used for the alpha channel of a darkening overlay. Use to darken your background image on the fly.
      '';
    };

    scaleImageCropped = mkOption {
      default = true;
      type = types.bool;
      description = ''
        Whether the image should be cropped when scaled proportionally. Setting this to false will fit the whole image instead, possibly leaving white space. This can be exploited beautifully with illustrations (try it with "undraw.svg" included in the theme).
      '';
    };

    screenWidth = mkOption {
      default = 1440;
      type = types.int;
      description = ''
        Adjust to your resolution to help SDDM speed up on calculations
      '';
    };

    screenHeight = mkOption {
      default = 900;
      type = types.int;
      description = ''
        Adjust to your resolution to help SDDM speed up on calculations
      '';
    };

    fullBlur = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Enable or disable the blur effect; if HaveFormBackground is set to true then PartialBlur will trigger the BackgroundColor of the form element to be partially transparent and blend with the blur.
      '';
    };

    partialBlur = mkOption {
      default = true;
      type = types.bool;
      description = ''
        Enable or disable the blur effect; if HaveFormBackground is set to true then PartialBlur will trigger the BackgroundColor of the form element to be partially transparent and blend with the blur.
      '';
    };

    blurRadius = mkOption {
      default = 100;
      type = types.int;
      description = ''
        Set the strength of the blur effect. Anything above 100 is pretty strong and might slow down the rendering time. 0 is like setting false for any blur.
      '';
    };

    haveFormBackground = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Have a full opacity background color behind the form that takes slightly more than 1/3 of screen estate;  if PartialBlur is set to true then HaveFormBackground will trigger the BackgroundColor of the form element to be partially transparent and blend with the blur.
      '';
    };

    # TODO: Should actually be a choice between left, center or right
    formPosition = mkOption {
      default = "left";
      type = types.str;
      description = ''
        Position of the form which takes roughly 1/3 of screen estate. Can be left, center or right.
      '';
    };

    # TODO: Should actually be a choice between left, center or right
    backgroundImageHAlignment = mkOption {
      default = "center";
      type = types.str;
      description = ''
        Horizontal position of the background picture relative to its visible area. Applies when ScaleImageCropped is set to false or when HaveFormBackground is set to true and FormPosition is either left or right. Can be left, center or right; defaults to center if none is passed.
      '';
    };

    # TODO: Should actually be a choice between left, center or right
    backgroundImageVAlignment = mkOption {
      default = "center";
      type = types.str;
      description = ''
        As before but for the vertical position of the background picture relative to its visible area.
      '';
    };

    mainColor = mkOption {
      default = "white";
      type = types.str;
      description = ''
        Used for all elements when not focused/hovered etc. Usually the best effect is achieved by having this be either white or a very dark grey like #444 (not black for smoother antialias)
        Colors can be HEX or Qt names (e.g. red/salmon/blanchedalmond). See https://doc.qt.io/qt-5/qml-color.html
      '';
    };

    accentColor = mkOption {
      default = "#fb884f";
      type = types.str;
      description = ''
        Used for elements in focus/hover/pressed. Should be contrasting to the background and the MainColor to achieve the best effect.
      '';
    };

    backgroundColor = mkOption {
      default = "#444";
      type = types.str;
      description = ''
        Used for the user and session selection background as well as for ScreenPadding and FormBackground when either is true. If PartialBlur and FormBackground are both enabled this color will blend with the blur effect.
      '';
    };

    overrideLoginButtonTextColor = mkOption {
      default = "";
      type = types.str;
      description = ''
        The text of the login button may become difficult to read depending on your color choices. Use this option to set it independently for legibility.
      '';
    };

    interfaceShadowSize = mkOption {
      default = 6;
      type = types.int;
      description = ''
        Integer used as multiplier. Size of the shadow behind the user and session selection background. Decrease or increase if it looks bad on your background. Initial render can be slow no values above 5-7.
      '';
    };

    interfaceShadowOpacity = mkOption {
      default = 0.6;
      type = types.float;
      description = ''
        Double between 0 and 1. Alpha channel of the shadow behind the user and session selection background. Decrease or increase if it looks bad on your background.
      '';
    };

    roundCorners = mkOption {
      default = 20;
      type = types.int;
      description = ''
        Integer in pixels. Radius of the input fields and the login button. Empty for square. Can cause bad antialiasing of the fields.
      '';
    };

    screenPadding = mkOption {
      default = 0;
      type = types.int;
      description = ''
        Integer in pixels. Increase or delete this to have a padding of color BackgroundColor all around your screen. This makes your login greeter appear as if it was a canvas. Cool!
      '';
    };

    # TODO: This might be better as a font package?
    font = mkOption {
      default = "Noto Sans";
      type = types.str;
      description = ''
        If you want to choose a custom font it will have to be available to the X root user. See https://wiki.archlinux.org/index.php/fonts#Manual_installation
      '';
    };

    fontSize = mkOption {
      default = "";
      type = types.int;
      description = ''
        Only set a fixed value if fonts are way too small for your resolution. Preferrably kept empty.
      '';
    };

    forceRightToLeft = mkOption {
      default = false;
      types = type.bool;
      description = ''
        Revert the layout either because you would like the login to be on the right hand side or SDDM won't respect your language locale for some reason. This will reverse the current position of FormPosition if it is either left or right and in addition position some smaller elements on the right hand side of the form itself (also when FormPosition is set to center).
      '';
    };

    forceLastUser = mkOption {
      default = true;
      types = type.bool;
      description = ''
        Have the last successfully logged in user appear automatically in the username field.
      '';
    };

    forcePasswordFocus = mkOption {
      default = true;
      types = type.bool;
      description = ''
        Give automatic focus to the password field. Together with ForceLastUser this makes for the fastest login experience.
      '';
    };

    forceHideCompletePassword = mkOption {
      default = false;
      types = type.bool;
      description = ''
        If you don't like to see any character at all not even while being entered set this to true.
      '';
    };

    forceHideVirtualKeyboardButton = mkOption {
      default = false;
      types = type.bool;
      description = ''
        Do not show the button for the virtual keyboard at all. This will completely disable functionality for the virtual keyboard even if it is installed and activated in sddm.conf
      '';
    };

    forceHideSystemButtons = mkOption {
      default = false;
      types = type.bool;
      description = ''
        Completely disable and hide any power buttons on the greeter.
      '';
    };

    allowEmptyPassword = mkOption {
      default = false;
      types = type.bool;
      description = ''
        Enable login for users without a password. This is discouraged. Makes the login button always enabled.
      '';
    };

    allowBadUsernames = mkOption {
      default = false;
      types = type.bool;
      description = ''
        Do not change this! Uppercase letters are generally not allowed in usernames. This option is only for systems that differ from this standard! Also shows username as is instead of capitalized.
      '';
    };

    locale = mkOption {
      default = "";
      types = type.str;
      description = ''
        The time and date locale should usually be set in your system settings. Only hard set this if something is not working by default or you want a seperate locale setting in your login screen.
      '';
    };

    hourFormat = mkOption {
      default = "HH:mm";
      types = type.str;
      description = ''
        Defaults to Locale.ShortFormat - Accepts "long" or a custom string like "hh:mm A". See http://doc.qt.io/qt-5/qml-qtqml-date.html
      '';
    };

    dateFormat = mkOption {
      default = "dddd, d of MMMM";
      types = type.str;
      description = ''
        Defaults to Locale.LongFormat - Accepts "short" or a custom string like "dddd, d 'of' MMMM". See http://doc.qt.io/qt-5/qml-qtqml-date.html
      '';
    };

    headerText = mkOption {
      default = "Welcome!";
      types = type.str;
      description = ''
        Header can be empty to not display any greeting at all. Keep it short.
      '';
    };

    translatePlaceholderUsername = mkOption {
      default = "";
      types = type.str;
      description = ''
        These don't necessarily need to translate anything. You can enter whatever you want here.
      '';
    };

    translatePlaceholderPassword = mkOption {
      default = "";
      types = type.str;
      description = ''
        These don't necessarily need to translate anything. You can enter whatever you want here.
      '';
    };

    translateShowPassword = mkOption {
      default = "";
      types = type.str;
      description = ''
        These don't necessarily need to translate anything. You can enter whatever you want here.
      '';
    };

    translateLogin = mkOption {
      default = "";
      types = type.str;
      description = ''
        These don't necessarily need to translate anything. You can enter whatever you want here.
      '';
    };

    translateLoginFailedWarning = mkOption {
      default = "";
      types = type.str;
      description = ''
        These don't necessarily need to translate anything. You can enter whatever you want here.
      '';
    };

    translateCapslockWarning = mkOption {
      default = "";
      types = type.str;
      description = ''
        These don't necessarily need to translate anything. You can enter whatever you want here.
      '';
    };

    translateSession = mkOption {
      default = "";
      types = type.str;
      description = ''
        These don't necessarily need to translate anything. You can enter whatever you want here.
      '';
    };

    translateSuspend = mkOption {
      default = "";
      types = type.str;
      description = ''
        These don't necessarily need to translate anything. You can enter whatever you want here.
      '';
    };

    translateHibernate = mkOption {
      default = "";
      types = type.str;
      description = ''
        These don't necessarily need to translate anything. You can enter whatever you want here.
      '';
    };

    translateReboot = mkOption {
      default = "";
      types = type.str;
      description = ''
        These don't necessarily need to translate anything. You can enter whatever you want here.
      '';
    };

    translateShutdown = mkOption {
      default = "";
      types = type.str;
      description = ''
        These don't necessarily need to translate anything. You can enter whatever you want here.
      '';
    };

    translateVirtualKeyboardButton = mkOption {
      default = "";
      types = type.str;
      description = ''
        These don't necessarily need to translate anything. You can enter whatever you want here.
      '';
    };
  };

  config = mkIf cfg.enable {
    themeConfUser = writeText "themeConfUser" ''
      [General]

      Background="${cfg.background}"
      DimBackgroundImage="${cfg.dimBackgroundImage}"
      ScaleImageCropped="${cfg.scaleImageCropped}"
      ScreenWidth="${cfg.screenWidth}"
      ScreenHeight="${cfg.screenHeight}"

      ## [Blur Settings]

      FullBlur="${cfg.fullBlur}"
      PartialBlur="${cfg.partialBlur}"
      BlurRadius="${cfg.blurRadius}"

      ## [Design Customizations]

      HaveFormBackground="${cfg.haveFormBackground}"
      FormPosition="${cfg.formPosition}"
      BackgroundImageHAlignment="${cfg.backgroundImageHAlignment}"
      BackgroundImageVAlignment="${cfg.backgroundImageVAlignment}"
      MainColor="${cfg.mainColor}"
      AccentColor="${cfg.accentColor}"
      BackgroundColor="${cfg.backgroundColor}"
      OverrideLoginButtonTextColor="${cfg.overrideLoginButtonTextColor}"
      InterfaceShadowSize="${cfg.interfaceShadowSize}"
      InterfaceShadowOpacity="${cfg.interfaceShadowOpacity}"
      RoundCorners="${cfg.roundCorners}"
      ScreenPadding="${cfg.screenPadding}"
      Font="${cfg.font}"
      FontSize="${cfg.fontSize}"

      ## [Interface Behavior]

      ForceRightToLeft="${cfg.forceRightToLeft}"
      ForceLastUser="${cfg.forceLastUser}"
      ForcePasswordFocus="${cfg.forcePasswordFocus}"
      ForceHideCompletePassword="${cfg.forceHideCompletePassword}"
      ForceHideVirtualKeyboardButton="${cfg.forceHideVirtualKeyboardButton}"
      ForceHideSystemButtons="${cfg.forceHideSystemButtons}"
      AllowEmptyPassword="${cfg.allowEmptyPassword}"
      AllowBadUsernames="${cfg.allowBadUsernames}"

      ## [Locale Settings]

      Locale="${cfg.locale}"
      HourFormat="${cfg.hourFormat}"
      DateFormat="${cfg.dateFormat}"

      ## [Translations]

      HeaderText="${cfg.headerText}"
      TranslatePlaceholderUsername="${cfg.translatePlaceholderUsername}"
      TranslatePlaceholderPassword="${cfg.translatePlaceholderPassword}"
      TranslateShowPassword="${cfg.translateShowPassword}"
      TranslateLogin="${cfg.translateLogin}"
      TranslateLoginFailedWarning="${cfg.translateLoginFailedWarning}"
      TranslateCapslockWarning="${cfg.translateCapslockWarning}"
      TranslateSession="${cfg.translateSession}"
      TranslateSuspend="${cfg.translateSuspend}"
      TranslateHibernate="${cfg.translateHibernate}"
      TranslateReboot="${cfg.translateReboot}"
      TranslateShutdown="${cfg.translateShutdown}"
      TranslateVirtualKeyboardButton="${cfg.translateVirtualKeyboardButton}"
    '';

    sddm-sugar-candy = pkgs.callPackage ../overlay/sddm-sugar-candy.nix {
      inherit (pkgs.libsForQt5) qtgraphicaleffects;
      inherit themeConfUser;
    };
  };
}
