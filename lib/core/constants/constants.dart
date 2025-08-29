import 'package:flutter/material.dart';

class AppStringConstants {
  static const String localeKey = 'app_locale';
  static const String defaultLocale = 'ar'; // Default language code
  static const String allUsersSubscribeToTopic = "all_users";
  static const String androidAppIcon = '@mipmap/ic_launcher';

  // static const double totalBottomPaddingForContent = 72.0 + 16.0;
}

class AppDimensConstants {
  static const double totalBottomPaddingForContent = 72.0 + 16.0;
  static const double mainHorizontalPadding = 16.0;
  static const EdgeInsets appBarHorizontalPadding =
      EdgeInsets.symmetric(horizontal: mainHorizontalPadding);
  static const EdgeInsets screenPadding = EdgeInsets.fromLTRB(
      mainHorizontalPadding, 8.0, mainHorizontalPadding, 16.0);
}
