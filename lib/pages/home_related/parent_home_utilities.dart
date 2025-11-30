import 'package:app/file/app_preferences/app_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreenUtilities {
  /// Using singleton pattern: to create only one instance of this class.
  static HomeScreenUtilities? _homeScreenUtilities;
  factory HomeScreenUtilities() {
    _homeScreenUtilities ??= HomeScreenUtilities._internal();
    return _homeScreenUtilities!;
  }

  HomeScreenUtilities._internal() {
    print("Building Home Screen...");
  }

  SystemUiOverlayStyle getSystemUiOverlayStyle() {
    return SystemUiOverlayStyle(
      statusBarColor: AppThemePreferences().appTheme.genericStatusBarColor,
      statusBarIconBrightness: AppThemePreferences().appTheme.genericStatusBarIconBrightness,
      statusBarBrightness: AppThemePreferences().appTheme.statusBarBrightness,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarContrastEnforced: false,
      systemStatusBarContrastEnforced: false,
    );
  }
}