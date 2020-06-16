import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ZephyrTheme {
  static const MaterialColor primarySwatch = Colors.blue;
  static const Color primaryColor = Color(0xff83d5d8);
  static const Color accentColor = primaryColor;

  static ThemeData getTheme([Brightness brightness = Brightness.light]) {
    return ThemeData(
      primarySwatch: primarySwatch,
      primaryColor: primaryColor,
      accentColor: accentColor,
      brightness: brightness,
    );
  }

  static void setSystemUIOverlayStyle({Brightness brightness, BuildContext context}) {
    if (brightness == null && context == null) throw ArgumentError("brightness and context cannot be both null.");

    if (brightness == null) brightness = getSystemBrightness(context);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: brightness == Brightness.light ? Colors.transparent : primaryColor,
      statusBarIconBrightness: ~brightness,
      systemNavigationBarColor: primaryColor,
    ));
  }

  static Brightness getSystemBrightness(BuildContext context) => MediaQuery.of(context).platformBrightness;

  static ThemeData getSystem(BuildContext context) => getTheme(getSystemBrightness(context));

  static Color getFontColor(BuildContext context) => getSystemBrightness(context).invert().color;

  static TextStyle getTextStyle(BuildContext context) => TextStyle(color: getFontColor(context));

  static IconThemeData getIconThemeData(BuildContext context) => IconThemeData(color: getFontColor(context));

  static ThemeData get light => getTheme(Brightness.light);

  static ThemeData get dark => getTheme(Brightness.dark);
}

extension BrightnessExtension on Brightness {
  Brightness invert() => this == Brightness.light ? Brightness.dark : Brightness.light;
  Brightness operator ~() => invert();

  Color get color => this == Brightness.light ? Colors.white : Colors.black;

  SystemUiOverlayStyle get systemUiOverlayStyle =>
      this == Brightness.light ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark;
}
