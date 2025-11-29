
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

  HomeScreenUtilities._internal(){}

  // Widget getHomeScreen({
  //   required GlobalKey<ScaffoldState> scaffoldKey,
  // }){
  //
  //   return HomeCarousel(scaffoldKey: scaffoldKey);
  // }

  SystemUiOverlayStyle getSystemUiOverlayStyle() {
    /// For Home Screen
    return SystemUiOverlayStyle(
        // statusBarColor: AppThemePreferences().appTheme
        //     .homeScreen02StatusBarColor,
        // statusBarIconBrightness: AppThemePreferences().appTheme
        //     .statusBarIconBrightness,
        // systemNavigationBarIconBrightness: Brightness.light,
        // statusBarBrightness: AppThemePreferences().appTheme.statusBarBrightness
        statusBarBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        // statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
    );
  }}