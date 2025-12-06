import 'package:app/file/common/constants.dart';
import 'package:app/file/generic_methods/utility_methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class AppThemePreferences{
  bool _isDark = false;
  // AppThemePreferences._internal(){}
  AppThemePreferences._internal();

  static AppThemePreferences? _appThemePreferences;
  factory AppThemePreferences() {
    _appThemePreferences ??= AppThemePreferences._internal();
    return _appThemePreferences!;
  }
  AppTheme _darkTheme = AppTheme(isDark: true);
  AppTheme _lightTheme = AppTheme(isDark: false);

  AppTheme get appTheme => _isDark ? _darkTheme : _lightTheme;
  void dark(bool darkMode) {
    _isDark = darkMode;
  }
  ///
  ///
  /// Card Elevation:
  ///
  ///
  static double globalCardElevation = 1.0;
  static double appBarWidgetElevation = 1.0;
  static double zeroElevation = 0.0;
  static double notificationWidgetElevation = 1.0;
  ///
  ///
  /// TextStyle FontSizes:
  ///
  ///
  /// These will be Removed in Future.
  static double normalFontSize = 12.0;
//   static double buttonFontSize = 18.0;
  static double headingFontSize = 20.0;
  static double heading02FontSize = 20.0;
  static double titleFontSize = 18.0;
  static double labelFontSize = 16.0;
  static double label01FontSize = 14.0;
  static double label02FontSize = 18.0;
  static double heading03FontSize = 18.0;
  static double bodyFontSize = 14.0;
  static double linkFontSize = 14.0;
  static double subBodyFontSize = 12.0;
  static double hintFontSize = normalFontSize;
  static double toastTextFontSize = 14.0;
  static double tabBarTitleFontSize = 15.0;
  static double infoCardTitleTextSize = 14.0;
  static double bottomSheetMenuTitle01FontSize = 24.0;
  static double bottomSheetMenuSubTitleFontSize = 14.0;
  static double genericStatusBarTextFontSize = 18.0;
  static double requestPermissionTextFontSize = 16.0;
  static double genericInfoCardHighlightTextSize = 22.0;
  static double batteryUsageCardTileIconSize = 16.0;
  static double genericAppBarTextFontSize = 25.0;
  static double genericTabBarTextFontSize = 18.0;
  static double appInfoTextFontSize = 16.0;
  static double settingOptionsTextFontSize = 16.0;
  static double settingHeadingTextFontSize = 18.0;
  static double settingHeadingSubtitleTextFontSize = 14.0;
  static double bottomSheetOptionsTextFontSize = 18.0;
  static double sliverGreetingsTextFontSize = 17.0;
  static double sliverUserNameTextFontSize = 30.0;
  static double batteryStatusHeadingFontSize = 70.0;
  static double batteryStatusSubTextFontSize = 15.0;

  ///
  ///
  /// TextStyle FontHeights:
  ///
  ///
  static double bodyTextHeight = 1.6;
  static double linkTextHeight = 1.5;
  static double settingHeadingSubtitleTextHeight = 1.4;
  static double bottomSheetMenuTitle01TextHeight = 1.4;
  static double genericTextHeight = 1.0;

  ///
  ///
  /// TextStyle FontWeights:
  ///
  ///
  static FontWeight lightFontWeight = FontWeight.w300;
  static FontWeight headingFontWeight = FontWeight.w400;
  static FontWeight heading02FontWeight = headingFontWeight;
  static FontWeight heading03FontWeight = FontWeight.w600;
  static FontWeight labelFontWeight = FontWeight.w500;
  static FontWeight label01FontWeight = FontWeight.w400;
  static FontWeight titleFontWeight = FontWeight.w600;
  static FontWeight bodyFontWeight = lightFontWeight;
  static FontWeight subBodyFontWeight = lightFontWeight;
  static FontWeight genericAppBarTextFontWeight = headingFontWeight;
  static FontWeight genericTabBarTextFontWeight = headingFontWeight;
  static FontWeight settingOptionsTextFontWeight = FontWeight.w500;
  static FontWeight settingHeadingTextFontWeight = FontWeight.bold;
  static FontWeight settingHeadingSubtitleTextFontWeight = FontWeight.w400;
  static FontWeight bottomSheetOptionsTextFontWeight = FontWeight.w400;
  static FontWeight sliverUserNameTextFontWeight = FontWeight.bold;

  ///
  ///
  /// TextStyle FontStyle:
  ///
  ///
//   static FontStyle risingLeadsTextFontStyle = FontStyle.normal;
//   static FontStyle fallingLeadsTextFontStyle = FontStyle.normal;
  ///
  ///
  /// Brightness:
  ///
  ///
  /// Brightness Light:
  ///
  /// System Brightness Light:
  static Brightness systemBrightnessLight = Brightness.light;
  ///
  /// Status Bar Icons Brightness Light:
  static Brightness statusBarIconBrightnessLight = Brightness.light;
  ///
  /// Generic Status Bar Icons Brightness Light:
  static Brightness genericStatusBarIconBrightnessLight = Brightness.dark;
  ///
  ///
  /// Brightness Dark:
  ///
  /// System Brightness Dark:
  static Brightness systemBrightnessDark = Brightness.dark;
  ///
  /// Status Bar Icons Brightness Dark:
  static Brightness statusBarIconBrightnessDark = Brightness.dark;
  ///
  /// Generic Status Bar Icons Brightness Dark:
  static Brightness genericStatusBarIconBrightnessDark = Brightness.light;
  ///
  ///
  /// System Ui Overlay Style:
  ///
  ///
  /// System Ui Overlay Style Light:
  static SystemUiOverlayStyle systemUiOverlayStyleLight = SystemUiOverlayStyle.light;
  ///
  /// System Ui Overlay Style Dark:
  static SystemUiOverlayStyle systemUiOverlayStyleDark = SystemUiOverlayStyle.dark;
  ///
  ///
  /// Colors:
  ///
  ///
  /// Primary Color Swatch of App:
  static MaterialColor appPrimaryColorSwatch = primaryColorSwatch;
  ///
  /// Secondary Color Swatch of App:
//   static MaterialColor appSecondaryColorSwatch = secondaryColorSwatch;
  ///
  /// Primary Color of App:
  static Color appPrimaryColor = APP_PRIMARY_COLOR;
  ///
  /// Secondary Color of App:
  static Color appSecondaryColor = APP_SECONDARY_COLOR;
  ///
  /// Master Color of App Icons:
  static Color appIconsMasterColorLight = appSecondaryColor;
  ///
  /// Master Color of App Icons:
  static Color appIconsMasterColorDark = Color(0xFF868a8d);
  ///
  /// Selected Item Text Color:
  static Color selectedItemTextColorLight = appSecondaryColor;
  ///
  /// Selected Item Text Color:
  static Color? selectedItemTextColorDark = Colors.grey[400];
  ///
  /// Un-Selected Item Text Color:
  static Color unSelectedItemTextColorLight = Colors.black54;
  ///
  /// Un-Selected Item Text Color:
  static Color? unSelectedItemTextColorDark = Colors.grey[800];
  ///
  /// Selected Item Background Color:
  static Color selectedItemBackgroundColorLight = appSecondaryColor.withOpacity(0.3);
  ///
  /// Selected Item Background Color:
  static Color? selectedItemBackgroundColorDark = Colors.grey[800];
  ///
  /// Un-Selected Item Background Color Light:
  static Color? unSelectedItemBackgroundColorLight = Colors.grey[100];
  ///
  /// Un-Selected Item Background Color:
  static Color? unSelectedItemBackgroundColorDark = Colors.grey[600];
  ///
  /// Dialog Background Color:
  static Color DialogBackgroundColor = Colors.black54;
  ///
  /// Link Color:
  static Color linkColor = appSecondaryColor;
  ///
  /// Search Bar 02 Background color Light
  static Color? searchBar02BackgroundColorLight = containerBackgroundColorLight;
  ///
  /// Search Bar Background color Dark
  static Color searchBarBackgroundColorDark = Color(0xFF3a3b3d);
  ///
  /// Rating Widget Stars color
  static Color ratingWidgetStarsColor = Colors.amber;
  ///
  /// Favourite Icon color
  static Color favouriteIconColor = Colors.red;
  ///
  /// Filled Button Icon color
  static Color filledButtonIconColor = Colors.white;
  ///
  /// Cancel Button Background color
  static Color cancelButtonBackgroundColor = Colors.white;
  ///
  /// Filled Button Text color
  static Color filledButtonTextColor = Colors.white;
  ///
  /// Label 02 Text color
  static Color label02TextColor = appSecondaryColor;
  ///
  /// Button Icon Text color
  static Color buttonIconColor = Colors.white;
  ///
  /// Toast Background color
  static Color? toastBackgroundColor = Colors.grey[800];
  ///
  /// Toast Text color
  static Color toastTextColor = Colors.white;
  ///
  /// Toast Button Background color
  static Color? toastButtonBackgroundColor = Colors.grey[800];
  // static Color toastButtonBackgroundColor = appPrimaryColor;
  ///
  /// No Internet Bottom Action Bar Background color
  static Color noInternetBottomActionBarBackgroundColor = Colors.red;
  ///
  /// Rising Leads Text Font color
  static Color risingLeadsColor = Colors.green;
  ///
  /// Falling Leads Text Font color
  static Color fallingLeadsColor = Colors.red;
  ///
  /// Radio Active Color
  static Color radioActiveColor = appPrimaryColor;
  ///
  /// Bottom Sheet Options Text Color
  static Color bottomSheetOptionsTextColor = appPrimaryColor;
  ///
  /// Tab bar indicator Color
  static Color tabBarIndicatorColor = Colors.white;
  ///
  /// Bottom Tab Bar Tint Color
  static Color bottomNavBarTintColor = appPrimaryColor;
  ///
  /// Bottom Tab Bar Tint Color
  static Color unSelectedBottomNavBarTintColor = Color(0xFF737373);
  ///
  /// App bottom bar background color
  static Color bottomNavBarBackgroundColorLight = Color(0xFFFAFAFA);
  ///
  /// Slider Tint Color
  static Color sliderTintColor = appSecondaryColor;
  ///
  /// Action Button Background Color
  static Color actionButtonBackgroundColor = appPrimaryColor;
  ///
  /// Form Field Border Color
  static Color formFieldBorderColor = appPrimaryColor;
  ///
  /// AppBar Action Widgets Text Font Color
  static Color appBarActionWidgetsTextFontColor = Colors.white;
  ///
  /// Notification Widget Icon Color
  static Color notificationWidgetIconColor = Colors.grey;
  ///
  /// Notification Widget Icon Bg Color
  static Color notificationWidgetIconBgColor = Colors.white;
  ///
  /// Notification Dot Color
  static Color notificationDotColor = Colors.red;
  ///
  /// Checked Icon Color
  static Color checkedIconColor = Colors.green;
  ///
  /// Graph Colors
  static final List<Color> colors = [
    Colors.pink,
    Colors.lightBlue,
    Colors.amber,
    Colors.cyan,
  ];
  ///
  ///
  ///
  /// Light Mode Colors:
  ///
  ///
  /// TextStyle related Light Colors:
  static Color? normalTextColorLight = Colors.grey[900];
  static Color? headingTextColorLight = Colors.grey[600];
  static Color labelTextColorLight = Colors.black;
  static Color? label01TextColorLight = normalTextColorLight;
  static Color titleTextColorLight = Colors.black;
  static Color bodyTextColorLight = Colors.black;
  static Color subBodyTextColorLight = Colors.black;
  static Color genericAppBarTextColorLight = Colors.black;
  static Color genericTabBarTextColorLight = Colors.black;
  static Color refreshIconColorLight = Colors.black;
  static Color hintColorLight = Colors.black54;
  static Color sliverGreetingsTextColorLight = Colors.white;
  static Color sliverUserNameTextColorLight = Colors.white;
  static Color? batteryStatusTextColorLight = Colors.black;
  static Color? batteryStatusSubTextColorLight = Colors.black38;
  static Color? cupertinoSegmentThumbColorLight = Colors.white;

  ///
  /// Bottom Navigation Bar color
  static Color? bottomNavBarColorLight = Colors.black;
  ///
  /// Bottom Nav Bar Un-Selected Item Text Color
  // static Color? bottomNavBarUnSelectedItemColorLight = Colors.grey[300];
  static Color? bottomNavBarUnSelectedItemColorLight = UNSELECTED_ITEM_COLOR;
  ///
  /// Generic Status Bar color
  static Color genericStatusBarColorLight =  Colors.transparent;
  ///
  /// Generic Status Bar Icons color
  static Color genericAppBarIconsColorLight =  Colors.white;
  ///
  /// SliverAppBar Background color
  static Color? sliverAppBarBackgroundColorLight =  Colors.grey[200];
  ///
  /// Background color
  static Color backgroundColorLight =  Colors.white;
  ///
  /// Generic Info Card Light Color
  static Color genericInfoCardColorLight = APP_LIGHT_COLOR;
  ///
  /// Generic Info Card Light Color
  static Color genericBorderColorLight = Color(0xFFF2F2F2);
  ///
  ///
  /// Divider color
  // static Color dividerColorLight =  Color(0x1F000000);
  static Color dividerColor = Colors.white54;
  ///
  /// Card color
  static Color cardColorLight =  Colors.white;
  ///
  /// Featured Tag Background color
  static Color? featuredTagBackgroundColorLight = Colors.grey[100];
  ///
  /// Featured Tag Border color
  static Color featuredTagBorderColorLight = appSecondaryColor.withOpacity(0.6);
  ///
  /// Tag Background color
  static Color? tagBackgroundColorLight = Colors.grey[100];
  ///
  /// Tag Border color
  static Color tagBorderColorLight = const Color(0x1F000000);
  ///
  /// Arrow Forward Icons color
  static Color arrowForwardIconsColorLight = Colors.deepOrange;
  ///
  /// Request Permission Text color
  static Color requestPermissionsTextColorLight = Colors.deepOrange;
  ///
  /// Highlight Color for Info card Color light
  static Color genericInfoCardHighlightTextColorLight = Colors.black;
  ///
  /// Generic Info Card Title Text color
  static Color genericInfoCardTitleTextColorLight =  Colors.black38;
  ///
  /// Property Details Page Top bar Icons color
  static Color propertyDetailsPageTopBarIconsColorLight = Colors.black;
  ///
  /// Property Details Page Top bar Icons Background color
  static Color propertyDetailsPageTopBarIconsBackgroundColorLight = Colors.white;
  ///
  /// Property Details Page Container Background color
  static Color? containerBackgroundColorLight = Colors.grey[100];
  ///
  /// Apple Sign-In Button Background color
  static Color circularGuageBackgroundColorLight = APP_LIGHT_COLOR;
  ///
  /// Bottom Sheet Bg color
  static Color bottomSheetBgColorLight = const Color(0xFFFAFAFA);
  ///
  /// Choice Chips Bg color
  static Color choiceChipsBgColorLight = const Color(0xFFEEEEEE);
  ///
  /// Pop Up Menu Bg color
  static Color dropdownMenuBgColorLight = const Color(0xFFFAFAFA);
  ///
  /// Dialog Bg color
  static Color dialogBgColorLight = const Color(0xFFFFFFFF);
  ///
  /// Popup Menu Bg color
  static Color popupMenuBgColorLight = const Color(0xFFFFFFFF);
  ///
  /// Notification Widget Bg Color Light
  static Color notificationWidgetBgColorLight = const Color(0xFFEEF1F4);
  ///
  /// Close Icon Color Light
  static Color closeIconColorLight = appSecondaryColor;
  ///
  /// Dark Mode Colors:
  ///
  ///
  ///TextStyle related Dark Colors:
  ///
  /// These will be removed in future
  static Color? normalTextColorDark = Colors.grey[400];
  static Color? headingTextColorDark = Colors.grey[400];
  static Color? labelTextColorDark = Colors.grey[300];
  static Color titleTextColorDark = Color(0xFFe1e2e6);
  static Color bodyTextColorDark = Color(0xFFcfd0d4);
  static Color subBodyTextColorDark = bodyTextColorDark;
  static Color? label01TextColorDark = normalTextColorDark;
  static Color? genericStatusBarTextColorDark = Colors.grey[400];
  static Color? genericAppBarTextColorDark = Colors.grey[300];
  static Color? genericTabBarTextColorDark = Colors.grey[300];
  static Color? refreshIconColorDark = Colors.white70;
  static Color hintColorDark = Colors.grey;
  static Color sliverGreetingsTextColorDark = Colors.white;
  static Color sliverUserNameTextColorDark = Colors.white;
  static Color? batteryStatusTextColorDark = normalTextColorDark;
  static Color? batteryStatusSubTextColorDark = Colors.grey;
  static Color? cupertinoSegmentThumbColorDark = normalTextColorDark;
  ///
  /// Bottom Navigation Bar color
  static Color? bottomNavBarColorDark = Colors.white;
//   static Color? bottomNavBarSelectedItemColorDark = APP_PRIMARY_COLOR;

  ///
  ///
  /// Generic Status Bar color
  static Color genericStatusBarColorDark =  Colors.transparent;
  ///
  /// Generic Status Bar Icons color
  static Color? genericAppBarIconsColorDark =  Colors.grey[300];
  ///
  /// SliverAppBar Background color
  static Color sliverAppBarBackgroundColorDark =  Color(0XFF242527);
  // static Color sliverAppBarBackgroundColorDark =  Colors.white10;
  // static Color sliverAppBarBackgroundColorDark =  Colors.white24;
  ///
  /// Background color
  static Color backgroundColorDark =  APP_SECONDARY_COLOR;
  ///
  /// Generic Info Card Dark Color
  static Color genericInfoCardColorDark = APP_DARK_COLOR;
  ///
  /// generic Border Color
  static Color genericBorderColorDark = Color(0xFF2A2A2A);
  ///
  // static Color backgroundColorDark =  Colors.black;
  ///
  /// Divider color
  static Color dividerColorDark =  Color(0x1FFFFFFF);
  ///
  /// Card color
  static Color cardColorDark =  Color(0XFF242527);
  // static Color cardColorDark =  Colors.grey[800];
  ///
  /// HomeScreen Search Bar Search Icon color
//   static Color homeScreenSearchBarIconColorDark = searchBarIconColorDark;
  static Color homeScreenSearchBarIconColorDark = unSelectedItemTextColorLight;
  // static Color homeScreenSearchBarIconColorDark = Colors.black;
  ///
  /// Featured Tag Background color
  static Color featuredTagBackgroundColorDark = const Color(0xFF3A3B3D);
  ///
  /// Featured Tag Border color
  static Color featuredTagBorderColorDark = appSecondaryColor.withOpacity(0.6);
  ///
  /// Tag Background color
  static Color tagBackgroundColorDark = const Color(0xFF3A3B3D);
  ///
  /// Tag Border color
  static Color tagBorderColorDark = const Color(0x1FFFFFFF);
  ///
  /// Filter Page Icons color
  static Color arrowForwardIconsColorDark = Colors.orangeAccent;
  ///
  /// Request Permission Text color
  static Color requestPermissionTextColorDark = Colors.orangeAccent;
  ///
  /// Request Permission Text color
  static Color genericInfoCardTitleTextColorDark = Colors.white70;
  ///
  /// 
  static Color genericInfoCardHighlightTextColorDark = Colors.white;
  ///
  /// Property Details Page Top bar Icons color
  static Color propertyDetailsPageTopBarIconsColorDark = Colors.black;
  ///
  /// Property Details Page Top bar Icons Background color
  static Color? propertyDetailsPageTopBarIconsBackgroundColorDark = Colors.grey[300];
  ///
  /// Circular Guage Background color
  static Color circularGuageBackgroundColorDark = APP_DARK_COLOR;
  ///
  /// App bottom bar background color
  static Color bottomNavBarBackgroundColorDark = APP_SECONDARY_COLORS;
  ///
  /// Bottom Sheet Bg color
  static Color bottomSheetBgColorDark = const Color(0xFF303030);
  ///
  /// Choice Chips Bg color
  static Color choiceChipsBgColorDark = const Color(0xFF757575);
  ///
  /// Pop Up Menu Bg color
  static Color popUpMenuBgColorDark = const Color(0xFF242527);
  ///
  /// Dropdown Menu Bg color
  static Color dropdownMenuBgColorDark = const Color(0xFF303030);
  ///
  /// Dialog Bg color
  static Color dialogBgColorDark = const Color(0xFF424242);
  ///
  /// Popup Menu Bg color
  static Color popupMenuBgColorDark = const Color(0xFF242527);
  ///
  /// Notification Widget Bg Color Dark
  static Color notificationWidgetBgColorDark = cardColorDark;
  ///
  /// Close Icon Dark
  static Color closeIconColorDark = appIconsMasterColorDark;

  ///
  ///
  /// Icons:
  ///
  ///
  /// Icon Sizes:
  static double normalIconSize = 24.0;
  static double genericBackButtonIconSize = 20.0;
  static double arrowForwardIconSize = 14.0;
  static double genericErrorWidgetIconSize = 140.0;
  static double settingsIconSize = 30.0;
  static double dotIconSize = 8.0;
  static double notificationWidgetIconSize = 50.0;
  static double checkIconSize = 25.0;
  final double defaultCanvasHeight = 600.0;
  final double defaultCanvasWidth   = 400.0;
  static double closeIconSize = 24.0;
  static double warningIconSize = 33.0;

  ///
  ///
  /// Icons Meta Data
  ///
  ///
  /// Voltage Icon
  static IconData voltageIcon = Icons.flash_on_outlined;
  ///
  /// Temperature Icon
  static IconData temperatureIcon = Icons.device_thermostat_outlined;
  ///
  /// Health Safty Icon
  static IconData healthSafetyIcon = Icons.health_and_safety;
  ///
  /// Refresh Icon
  static IconData refreshIconData = Icons.refresh;
  ///
  /// Privacy Tipes Icon
  static IconData privacyTipsIcon = Icons.privacy_tip_outlined;
  ///
  /// Electric Bolt Icon
  static IconData electricBoltIcon = Icons.electric_bolt_outlined;
  ///
  /// Screen Rotate lock icon
  static IconData screenLockIcon = Icons.screen_lock_portrait;
  ///
  /// Report a bug Icon
  static IconData bugReportIcon = Icons.bug_report_outlined;
  ///
  /// Get a idea bulb icon
  static IconData bulbIcon = Icons.lightbulb_outline_rounded;
  ///
  /// Down Arrow in Location Widget Icon
  static IconData dropDownArrowIcon = Icons.keyboard_arrow_down;
  ///
  /// Search Icon
  static IconData searchIcon = Icons.search;
  ///
  /// Arrow Back Icon
  static IconData arrowBackIcon = Icons.arrow_back;
  ///
  /// Close Icon
  static IconData closeIcon = Icons.close_outlined;
  ///
  /// Email Icon
  static IconData emailIcon = Icons.email_outlined;
  ///
  /// Notifcation Format Icon
  static IconData notificationFormat = Icons.notifications_active_outlined;
  ///
  /// No Internet Icon
  static IconData noInternetIcon = Icons.wifi_off_rounded;
  ///
  /// Activities Icon
  static IconData activitiesIcon = Icons.article_outlined;
  ///
  /// Settings Icon
  static IconData settingsIcon = Icons.settings_rounded;
  ///
  /// Remove Circle Outlined Icon
  static IconData removeCircleOutlinedIcon = Icons.remove_circle_outline_outlined;
  ///
  /// Add Circle Outlined Icon
  static IconData addCircleOutlinedIcon = Icons.add_circle_outline_outlined;
  ///
  /// Star Outlined Icon
  static IconData starOutlinedIcon = Icons.star_outline_outlined;
  ///
  /// Share Icon
  static IconData shareIconOutlined = Icons.share_outlined;
  ///
  /// Star Filled Icon
  static IconData starFilledIcon = Icons.star;
  ///
  /// Check Icon
  static IconData checkIcon = Icons.check;
  ///
  /// Arrow Forward Icon
  static IconData arrowForwardIcon = Icons.arrow_forward_ios;
  ///
  /// Share Icon
  static IconData shareIcon = Icons.share;
  ///
  /// Error Icon
  static IconData errorIcon = Icons.error_outlined;
  ///
  /// Assignment Icon
  static IconData assignmentIcon = Icons.assignment_outlined;
  ///
  /// Link Icon
  static IconData linkIcon = Icons.link_outlined;
  ///
  /// Dark mode Icon
  static IconData darkModeIcon = Icons.dark_mode_outlined;
  ///
  /// Language Icon
  static IconData languageIcon = Icons.translate_outlined;
  ///
  /// Invite Friends Icon
  static IconData inviteFriendsIcon = Icons.people_alt_outlined;
  ///
  /// Terms and Conditions Icon
  static IconData gravelIcon = Icons.gavel_outlined;
  ///
  /// Policy Icon
  static IconData policyIcon = Icons.policy_outlined;
  ///
  /// Help and Support Icon
  static IconData helpAndSupportIcon = Icons.help_outline_rounded;
  ///
  /// Water Mark Icon
  static IconData waterMarkIcon = Icons.water_drop_outlined;
  ///
  /// Circle dot Icon
  static IconData dotIcon = Icons.circle;
  ///
  /// Website Icon
  static IconData websiteIcon = Icons.language_outlined;
  ///
  /// List Icon
  static IconData messageIcon = Icons.message_outlined;
  ///
  /// Timer Icon
  static IconData timerOutlined = Icons.timer_outlined;
  ///
  /// Private note/description Icon
  static IconData descriptionOutlined = Icons.description_outlined;
  ///
  /// Notification Outlined Icon
  static IconData notificationIcon = Icons.notifications_outlined;
  ///
  /// Notification Outlined Icon
  static IconData notificationReviewIcon = Icons.sms_outlined;
  ///
  ///
  ///
  /// Icons Buttons:
  ///
  ///
  /// Icon Button Sizes:
  static double addPropertyDetailsIconButtonSize = 35.0;
  ///
  ///
  /// Navy Bottom Navigation Bar Height:
  static double dotBottomNavigationBarHeight = 55.0;

  ///
  ///
  ///
  /// Images:
  ///
  ///
  ///
  /// Image Sizes:
  ///
  ///
  ///
  /// Border Related:
  ///
  ///
  ///
  /// Border Width:
  ///
  ///
  /// Buttons:
  ///
  ///
  ///
  /// Button Heights:
  ///
  /// Filter Search Button:
  ///
  ///
  /// Loading Widgets:
  ///
  ///
  ///
  /// Dimensions of Loading Widgets:
  ///
  /// Pagination Loading Widget:
//   static double paginationLoadingWidgetHeight = 50.0;
//   static double paginationLoadingWidgetWidth = 60.0;
  ///
  ///
  /// Rounded Corners:
  ///
  ///
  /// Rounded Corners Radius:
  static double globalRoundedCornersRadius = 12.0;
  static double notificationWidgetRoundedCornersRadius = 10.0;
  ///
  ///
  /// Input Rounded Corners:
  static RoundedRectangleBorder roundedCorners(double radius, {
    BorderSide side = BorderSide.none,
  }) {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
      side: side,
      // side: BorderSide(color: AppThemePreferences().appTheme.dividerColor, width: 0.5)
    );
  }
  ///
  ///
  /// Input Fields Decoration:
  ///
  ///
  /// Input Fields Decoration:
  static InputDecoration formFieldDecoration({
    String? hintText,
    Widget? suffixIcon,
    bool hideBorder = false,
    BorderRadius? borderRadius,
    TextStyle? hintTextStyle,
    Color? focusedBorderColor,
    Color? prefixIconColor,
    Color? suffixIconColor,
    EdgeInsetsGeometry? contentPadding,
  }){
    return InputDecoration(
      hintText: hintText != null ? UtilityMethods.getLocalizedString(hintText): hintText,
      hintStyle: hintTextStyle,
      contentPadding: contentPadding ?? const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
      border: hideBorder ? InputBorder.none : OutlineInputBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(AppThemePreferences.globalRoundedCornersRadius),
        borderSide: BorderSide(color: focusedBorderColor ?? AppThemePreferences.formFieldBorderColor),
      ),
      focusedBorder: hideBorder ? InputBorder.none : OutlineInputBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(AppThemePreferences.globalRoundedCornersRadius),
        borderSide: BorderSide(color: focusedBorderColor ?? AppThemePreferences.formFieldBorderColor),
      ),
      // enabledBorder: OutlineInputBorder(
      //   borderRadius: BorderRadius.circular(AppThemePreferences.globalRoundedCornersRadius),
      //   // borderSide: BorderSide(color: Colors.red),
      // ),
      suffixIcon: suffixIcon,
      prefixIconColor: prefixIconColor,
      suffixIconColor: suffixIconColor,
      focusColor: focusedBorderColor,
    );
  }
  ///
  /// Divider Decoration:
  static Decoration dividerDecoration({
    bool top = false,
    bool bottom = false,
    bool left = false,
    bool right = false,
    double width = 1.0,
    BorderStyle style = BorderStyle.solid
  }){
    BoxBorder border;
    Color? borderColor = AppThemePreferences().appTheme.dividerColor;
    BorderSide borderSide = BorderSide(color: borderColor!, width: width, style: style);

    if(top == bottom && bottom == left && left == right && right == false){
      bottom = true;
    }

    border = Border(
      top: top == true ?  borderSide : BorderSide.none,
      bottom: bottom == true ?  borderSide : BorderSide.none,
      left: left == true ?  borderSide : BorderSide.none,
      right: right == true ?  borderSide : BorderSide.none,
    );

    return BoxDecoration(
      border: border,
    );
  }
  ///
  ///
  /// Widgets Size:
  ///
  ///
}



class AppTheme{
  final bool isDark;
  AppTheme({this.isDark = false}) {
    /// These all will be remove in future, so don't use them.
    /// textStyles:
    _headingTextStyle = TextStyle(fontSize: AppThemePreferences.headingFontSize, fontWeight: AppThemePreferences.headingFontWeight, color: isDark ? AppThemePreferences.headingTextColorDark : AppThemePreferences.headingTextColorLight);
    _heading02TextStyle = TextStyle(fontSize: AppThemePreferences.heading02FontSize, fontWeight: AppThemePreferences.heading02FontWeight, color: AppThemePreferences.appPrimaryColor);
    _heading03TextStyle = TextStyle(fontSize: AppThemePreferences.heading03FontSize, fontWeight: AppThemePreferences.heading03FontWeight, color: isDark ? AppThemePreferences.headingTextColorDark : AppThemePreferences.headingTextColorLight);
    _labelTextStyle = TextStyle(fontSize: AppThemePreferences.labelFontSize, fontWeight: AppThemePreferences.labelFontWeight, color: isDark ? AppThemePreferences.labelTextColorDark : AppThemePreferences.labelTextColorLight);
    _label01TextStyle = TextStyle(fontSize: AppThemePreferences.label01FontSize, fontWeight: AppThemePreferences.label01FontWeight, color: isDark ? AppThemePreferences.label01TextColorDark : AppThemePreferences.label01TextColorLight);
    _label02TextStyle = TextStyle(fontSize: AppThemePreferences.label02FontSize, color: AppThemePreferences.label02TextColor);
    _titleTextStyle = TextStyle(fontSize: AppThemePreferences.titleFontSize, fontWeight: AppThemePreferences.titleFontWeight, color: isDark ? AppThemePreferences.titleTextColorDark : AppThemePreferences.titleTextColorLight);
    _bodyTextStyle = TextStyle(fontSize: AppThemePreferences.bodyFontSize, height: AppThemePreferences.bodyTextHeight, fontWeight: AppThemePreferences.bodyFontWeight, color: isDark ? AppThemePreferences.bodyTextColorDark : AppThemePreferences.bodyTextColorLight);
    _linkTextStyle = TextStyle(fontSize: AppThemePreferences.linkFontSize, height: AppThemePreferences.linkTextHeight, color: AppThemePreferences.linkColor);
    _hintTextStyle = TextStyle(fontSize: AppThemePreferences.hintFontSize, color: isDark ? AppThemePreferences.hintColorDark : AppThemePreferences.hintColorLight);
    _toastTextTextStyle = TextStyle(fontSize: AppThemePreferences.toastTextFontSize, color: AppThemePreferences.toastTextColor);
    _bottomSheetMenuTitle01TextStyle = TextStyle(fontSize: AppThemePreferences.bottomSheetMenuTitle01FontSize, height: AppThemePreferences.bottomSheetMenuTitle01TextHeight);
    _bottomSheetMenuSubTitleTextStyle = TextStyle(fontSize: AppThemePreferences.bottomSheetMenuSubTitleFontSize);
    _settingOptionsTextStyle = TextStyle(fontSize: AppThemePreferences.settingOptionsTextFontSize, fontWeight: AppThemePreferences.settingOptionsTextFontWeight, color: isDark ? AppThemePreferences.normalTextColorDark : AppThemePreferences.normalTextColorLight);
    _settingHeadingTextStyle = TextStyle(fontSize: AppThemePreferences.settingHeadingTextFontSize, fontWeight: AppThemePreferences.settingHeadingTextFontWeight, color: isDark ? AppThemePreferences.normalTextColorDark : AppThemePreferences.normalTextColorLight);
    _settingHeadingSubTitleTextStyle = TextStyle(fontSize: AppThemePreferences.settingHeadingSubtitleTextFontSize, fontWeight: AppThemePreferences.settingHeadingSubtitleTextFontWeight, height: AppThemePreferences.settingHeadingSubtitleTextHeight, color: isDark ? AppThemePreferences.normalTextColorDark : AppThemePreferences.normalTextColorLight);
    _genericAppBarTextStyle = TextStyle(fontSize: AppThemePreferences.genericAppBarTextFontSize, fontWeight: AppThemePreferences.genericAppBarTextFontWeight, color: isDark ? AppThemePreferences.genericAppBarTextColorDark : AppThemePreferences.genericAppBarTextColorLight);
    _requestPermissionTextStyle = TextStyle(fontSize: AppThemePreferences.requestPermissionTextFontSize, fontWeight: FontWeight.bold, color: isDark ? AppThemePreferences.requestPermissionTextColorDark : AppThemePreferences.requestPermissionsTextColorLight,);
    _genericInfoCardTitleTextStyle = TextStyle(color: isDark ? AppThemePreferences.genericInfoCardTitleTextColorDark : AppThemePreferences.genericInfoCardTitleTextColorLight, fontSize: AppThemePreferences.infoCardTitleTextSize);
    _genericInfoCardHighlightTextStyle = TextStyle(fontSize: AppThemePreferences.genericInfoCardHighlightTextSize, fontWeight: FontWeight.bold, color: isDark ? AppThemePreferences.genericInfoCardHighlightTextColorDark : AppThemePreferences.genericInfoCardHighlightTextColorLight);
    _genericTabBarTextStyle = TextStyle(fontSize: AppThemePreferences.genericTabBarTextFontSize, fontWeight: AppThemePreferences.genericTabBarTextFontWeight, );
    _bottomSheetOptionsTextStyle = TextStyle(fontSize: AppThemePreferences.bottomSheetOptionsTextFontSize, color: AppThemePreferences.bottomSheetOptionsTextColor, fontWeight: AppThemePreferences.bottomSheetOptionsTextFontWeight);
    _sliverGreetingsTextStyle = TextStyle(fontSize: AppThemePreferences.sliverGreetingsTextFontSize, color: isDark ? AppThemePreferences.sliverGreetingsTextColorDark : AppThemePreferences.sliverGreetingsTextColorLight);
    _sliverUserNameTextStyle = TextStyle(fontSize: AppThemePreferences.sliverUserNameTextFontSize,  fontWeight: AppThemePreferences.sliverUserNameTextFontWeight, color: isDark ? AppThemePreferences.sliverUserNameTextColorDark : AppThemePreferences.sliverUserNameTextColorLight);
    _batteryStatusHeadingTextStyle = TextStyle(fontSize: AppThemePreferences.batteryStatusHeadingFontSize, fontWeight: FontWeight.bold, color: isDark ? AppThemePreferences.batteryStatusTextColorDark : AppThemePreferences.batteryStatusTextColorLight);
    _batteryStatusSubTextStyle = TextStyle(fontSize: AppThemePreferences.batteryStatusSubTextFontSize,  color: isDark ? AppThemePreferences.batteryStatusSubTextColorDark : AppThemePreferences.batteryStatusSubTextColorLight);
    /// Brightness:
    _statusBarBrightness  = isDark ? AppThemePreferences.statusBarIconBrightnessDark : AppThemePreferences.statusBarIconBrightnessLight;
    _statusBarIconBrightness = isDark ? AppThemePreferences.statusBarIconBrightnessLight : AppThemePreferences.statusBarIconBrightnessDark;
    _genericStatusBarIconBrightness = isDark ? AppThemePreferences.genericStatusBarIconBrightnessDark : AppThemePreferences.genericStatusBarIconBrightnessLight;
    /// SystemUiOverlayStyle:
    _systemUiOverlayStyle = isDark ? AppThemePreferences.systemUiOverlayStyleLight : AppThemePreferences.systemUiOverlayStyleDark;
    /// colors:
    ///
    _primaryColor = AppThemePreferences.appPrimaryColor;
    _normalTextColor = (isDark ? AppThemePreferences.normalTextColorDark : AppThemePreferences.normalTextColorLight)!;
    _iconsColor = isDark ? AppThemePreferences.appIconsMasterColorDark : AppThemePreferences.appIconsMasterColorLight;
    _genericStatusBarColor = isDark ? AppThemePreferences.genericStatusBarColorDark : AppThemePreferences.genericStatusBarColorLight;
    _unselectedTabLabelColor = isDark ? AppThemePreferences.genericTabBarTextColorDark : AppThemePreferences.genericTabBarTextColorLight;
    _genericAppBarIconsColor = (isDark ? AppThemePreferences.genericAppBarIconsColorDark : AppThemePreferences.genericAppBarIconsColorLight)!;
    _selectedItemTextColor = (isDark ? AppThemePreferences.selectedItemTextColorDark : AppThemePreferences.selectedItemTextColorLight)!;
    _unSelectedItemTextColor = (isDark ? AppThemePreferences.unSelectedItemTextColorDark : AppThemePreferences.unSelectedItemTextColorLight)!;
    _selectedItemBackgroundColor = (isDark ? AppThemePreferences.selectedItemBackgroundColorDark : AppThemePreferences.selectedItemBackgroundColorLight)!;
    _unSelectedItemBackgroundColor = (isDark ? AppThemePreferences.unSelectedItemBackgroundColorDark : AppThemePreferences.unSelectedItemBackgroundColorLight)!;
    _sliverAppBarBackgroundColor = (isDark ? AppThemePreferences.sliverAppBarBackgroundColorDark : AppThemePreferences.sliverAppBarBackgroundColorLight)!;
    _backgroundColor = isDark ? AppThemePreferences.backgroundColorDark : AppThemePreferences.backgroundColorLight;
    _genericInfoCardColor = isDark ? AppThemePreferences.genericInfoCardColorDark : AppThemePreferences.genericInfoCardColorLight;
    _genericBorderColor = isDark ? AppThemePreferences.genericBorderColorDark : AppThemePreferences.genericBorderColorLight;
    _dividerColor = isDark ? AppThemePreferences.dividerColorDark : AppThemePreferences.dividerColor;
    _cardColor = isDark ? AppThemePreferences.cardColorDark : AppThemePreferences.cardColorLight;
    _hintColor = isDark ? AppThemePreferences.hintColorDark : AppThemePreferences.hintColorLight;
    // _homeScreenTopBarRightArrowBackgroundColor = isDark ? AppThemePreferences.homeScreenTopBarRightArrowBackgroundColorDark : AppThemePreferences.homeScreenTopBarRightArrowBackgroundColorLight;
    _searchBar02BackgroundColor = (isDark ? AppThemePreferences.searchBarBackgroundColorDark : AppThemePreferences.searchBar02BackgroundColorLight)!;
    _featuredTagBackgroundColor = isDark ? AppThemePreferences.featuredTagBackgroundColorDark : AppThemePreferences.featuredTagBackgroundColorLight;
    _featuredTagBorderColor = isDark ? AppThemePreferences.featuredTagBorderColorDark : AppThemePreferences.featuredTagBorderColorLight;
    _tagBackgroundColor = isDark ? AppThemePreferences.tagBackgroundColorDark : AppThemePreferences.tagBackgroundColorLight;
    _tagBorderColor = isDark ? AppThemePreferences.tagBorderColorDark : AppThemePreferences.tagBorderColorLight;
    _propertyDetailsPageTopBarIconsColor = isDark ? AppThemePreferences.propertyDetailsPageTopBarIconsColorDark : AppThemePreferences.propertyDetailsPageTopBarIconsColorLight;
    _propertyDetailsPageTopBarIconsBackgroundColor = (isDark ? AppThemePreferences.propertyDetailsPageTopBarIconsBackgroundColorDark : AppThemePreferences.propertyDetailsPageTopBarIconsBackgroundColorLight)!;
    _circularGuageBackgroundColor = isDark ? AppThemePreferences.circularGuageBackgroundColorDark : AppThemePreferences.circularGuageBackgroundColorLight;
    _bottomNavBarBackgroundColor = isDark ? AppThemePreferences.bottomNavBarBackgroundColorDark : AppThemePreferences.bottomNavBarBackgroundColorLight;
    _cupertinoSegmentThumbColor = isDark ? AppThemePreferences.cupertinoSegmentThumbColorDark : AppThemePreferences.cupertinoSegmentThumbColorLight;
    _bottomSheetBgColor = isDark ? AppThemePreferences.bottomSheetBgColorDark : AppThemePreferences.bottomSheetBgColorLight;
    _choiceChipsBgColor = isDark ? AppThemePreferences.choiceChipsBgColorDark : AppThemePreferences.choiceChipsBgColorLight;
    _popUpMenuBgColor = isDark ? AppThemePreferences.popUpMenuBgColorDark : AppThemePreferences.popupMenuBgColorLight;
    _dropdownMenuBgColor = isDark ? AppThemePreferences.dropdownMenuBgColorDark : AppThemePreferences.dropdownMenuBgColorLight;
    _notificationWidgetBgColor = isDark ? AppThemePreferences.notificationWidgetBgColorDark : AppThemePreferences.notificationWidgetBgColorLight;
    // _bottomNavigationBarBackgroundColor = (isDark ? AppThemePreferences.bottomNavBarColorDark : AppThemePreferences.bottomNavBarColorLight)!;
    _bottomNavigationBarSelectedItemColor = AppThemePreferences.appPrimaryColor ;
    _bottomNavigationBarUnSelectedItemColor = (isDark ? AppThemePreferences.bottomNavBarUnSelectedItemColorLight : AppThemePreferences.bottomNavBarUnSelectedItemColorLight)!;
    /// icons:
    /// These all will be remove in future, so don't use them.
    _voltageIcon = Icon(AppThemePreferences.voltageIcon, color: AppThemePreferences.appPrimaryColor);
    _tempratureIcon = Icon(AppThemePreferences.temperatureIcon, color: AppThemePreferences.appPrimaryColor);
    _healthAndSafeIcon = Icon(AppThemePreferences.healthSafetyIcon, color: AppThemePreferences.appPrimaryColor);
    _refreshIcon = Icon(AppThemePreferences.refreshIconData, color: isDark ? AppThemePreferences.refreshIconColorDark : AppThemePreferences.refreshIconColorLight);
    _requestPermissionIcon = Icon(AppThemePreferences.arrowForwardIcon, size: AppThemePreferences.arrowForwardIconSize, color: isDark ? AppThemePreferences.arrowForwardIconsColorDark : AppThemePreferences.arrowForwardIconsColorLight,);
    _powerIcon = Icon(AppThemePreferences.electricBoltIcon, color: AppThemePreferences.appPrimaryColor);
    _screenTimeIcon = Icon(AppThemePreferences.screenLockIcon, color: AppThemePreferences.appPrimaryColor);
    _genericBackButtonIcon = Icon(AppThemePreferences.arrowBackIcon, size: AppThemePreferences.genericBackButtonIconSize,color: isDark ? AppThemePreferences.genericAppBarTextColorDark : AppThemePreferences.genericAppBarTextColorLight);
    _checkIcon = Icon(AppThemePreferences.checkIcon, size: AppThemePreferences.checkIconSize, color: AppThemePreferences.checkedIconColor);
    _closeIcon = Icon(AppThemePreferences.closeIcon, size: AppThemePreferences.closeIconSize, color: isDark ? AppThemePreferences.closeIconColorDark : AppThemePreferences.closeIconColorLight);
    ///
    /// images:
    /// images path:
    /// iconData:
    /// border side:
  }
  ///
  ///
  /// TextStyles:
  ///
  ///
  /// Heading Style for Main Heading of App in Light Mode e.g. Featured Properties, Latest Properties etc.
  TextStyle? _headingTextStyle;
  TextStyle? get headingTextStyle => _headingTextStyle;
  ///
  /// Bold Heading Style for Main Heading of App in Light Mode e.g. Featured Properties, Latest Properties etc.
  TextStyle? _heading03TextStyle;
  TextStyle? get heading03TextStyle => _heading03TextStyle;
  ///
  /// Heading Style with FontWeight.w400 and Primary Color for Item titles.
  TextStyle? _heading02TextStyle;
  TextStyle? get heading02TextStyle => _heading02TextStyle;
  ///
  /// normalTextStyle1 for Normal text e.g. Labels, Text Fields, Form Field etc.
  TextStyle? _labelTextStyle;
  TextStyle? get labelTextStyle => _labelTextStyle;
  ///
  /// _label01TextStyle for the Labels e.g. Property Detailed Features Property Id: , Price: etc.
  TextStyle? _label01TextStyle;
  TextStyle? get label01TextStyle => _label01TextStyle;
  ///
  /// _label02TextStyle for the Primary Colored Labels.
  TextStyle? _label02TextStyle;
  TextStyle? get label02TextStyle => _label02TextStyle;
  ///
  /// _titleTextStyle is bold for Item title e.g. Apartment at riverside etc.
  TextStyle? _titleTextStyle;
  TextStyle? get titleTextStyle => _titleTextStyle;
  ///
  /// bodyText for normal body text e.g. Property Description, Any Message, Comments etc.
  TextStyle? _bodyTextStyle;
  TextStyle? get bodyTextStyle => _bodyTextStyle;
  ///
  /// _body03TextStyle for Primary colored body text without any height and weight
  TextStyle? _linkTextStyle;
  TextStyle? get linkTextStyle => _linkTextStyle;
  ///
  /// _hintTextStyle for the Hint text.
  TextStyle? _hintTextStyle;
  TextStyle? get hintTextStyle => _hintTextStyle;
  ///
  /// _toastTextTextStyle for the Text of Toast.
  TextStyle? _toastTextTextStyle;
  TextStyle? get toastTextTextStyle => _toastTextTextStyle;
  ///
  /// _bottomNavigationMenuTitle01TextStyle for the Title of Bottom Navigation Menu.
  TextStyle? _bottomSheetMenuTitle01TextStyle;
  TextStyle? get bottomSheetMenuTitle01TextStyle => _bottomSheetMenuTitle01TextStyle;
  ///
  /// _bottomSheetMenuSubTitleTextStyle for the Title of Bottom Navigation Menu.
  TextStyle? _bottomSheetMenuSubTitleTextStyle;
  TextStyle? get bottomSheetMenuSubTitleTextStyle => _bottomSheetMenuSubTitleTextStyle;
  ///
  /// Generic StatusBar TextStyle.
  TextStyle? _genericAppBarTextStyle;
  TextStyle? get genericAppBarTextStyle => _genericAppBarTextStyle;
  ///
  /// Generic TabBar TextStyle.
  TextStyle? _genericTabBarTextStyle;
  TextStyle? get genericTabBarTextStyle => _genericTabBarTextStyle;
  ///
  /// Generic Info Card Text Style
  TextStyle? _genericInfoCardTitleTextStyle;
  TextStyle? get genericInfoCardTitleTextStyle => _genericInfoCardTitleTextStyle;
  ///
  /// Request Permission Text Style
  TextStyle? _requestPermissionTextStyle;
  TextStyle? get requestPermissionTextStyle => _requestPermissionTextStyle;
  ///
  /// Generic Info Card Highlight TextSyle
  TextStyle? _genericInfoCardHighlightTextStyle;
  TextStyle? get genericInfoCardHighlightTextStyle => _genericInfoCardHighlightTextStyle;
  ///
  ///  Setting Options TextStyle.
  TextStyle? _settingOptionsTextStyle;
  TextStyle? get settingOptionsTextStyle => _settingOptionsTextStyle;
  ///
  ///  Setting Heading TextStyle.
  TextStyle? _settingHeadingTextStyle;
  TextStyle? get settingHeadingTextStyle => _settingHeadingTextStyle;
  ///
  ///  Setting Heading SubTitle TextStyle.
  TextStyle? _settingHeadingSubTitleTextStyle;
  TextStyle? get settingHeadingSubTitleTextStyle => _settingHeadingSubTitleTextStyle;
  ///
  ///  Bottom Sheet Options TextStyle.
  TextStyle? _bottomSheetOptionsTextStyle;
  TextStyle? get bottomSheetOptionsTextStyle => _bottomSheetOptionsTextStyle;
  ///
  ///  Sliver Greetings TextStyle.
  TextStyle? _sliverGreetingsTextStyle;
  TextStyle? get sliverGreetingsTextStyle => _sliverGreetingsTextStyle;
  ///
  ///  Sliver User Name TextStyle.
  TextStyle? _sliverUserNameTextStyle;
  TextStyle? get sliverUserNameTextStyle => _sliverUserNameTextStyle;
  ///
  /// Battery Status TextStyle.
  TextStyle? _batteryStatusHeadingTextStyle;
  TextStyle? get batteryStatusTextStyle => _batteryStatusHeadingTextStyle;
  ///
  /// Battery Status Sub text TextStyle.
  TextStyle? _batteryStatusSubTextStyle;
  TextStyle? get batteryStatusSubTextStyle => _batteryStatusSubTextStyle;

  ///
  ///
  /// Brightness:
  ///
  ///
  /// Status Bar Icons Brightness:
  Brightness? _statusBarIconBrightness;
  Brightness? get statusBarIconBrightness => _statusBarIconBrightness;

  ///
  ///
  /// Brightness:
  ///
  ///
  /// Status Bar Brightness (iOS):
  Brightness? _statusBarBrightness;
  Brightness? get statusBarBrightness => _statusBarBrightness;
  ///
  /// Generic Status Bar Icons Brightness:
  Brightness? _genericStatusBarIconBrightness;
  Brightness? get genericStatusBarIconBrightness => _genericStatusBarIconBrightness;
  ///
  ///
  /// System Ui Overlay Style:
  ///
  ///
  /// SystemUiOverlayStyle:
  SystemUiOverlayStyle? _systemUiOverlayStyle;
  SystemUiOverlayStyle? get systemUiOverlayStyle => _systemUiOverlayStyle;
  ///
  ///
  /// Color Styles:
  ///
  ///
  /// App Primary Color
  Color? _primaryColor;
  Color? get primaryColor => _primaryColor;
  ///
  /// Normal Text Color
  Color? _normalTextColor;
  Color? get bodyTextColor => _normalTextColor;
  ///
  /// Icon color
  Color? _iconsColor;
  Color? get iconsColor => _iconsColor;
  ///
  /// Generic Info Card Color
  Color? _genericInfoCardColor;
  Color? get genericInfoCardColor => _genericInfoCardColor;
  ///
  /// Generic Border Color
  Color? _genericBorderColor;
  Color? get genericBorderColor => _genericBorderColor;
  ///
  /// Generic Status Bar color
  Color? _genericStatusBarColor;
  Color? get genericStatusBarColor => _genericStatusBarColor;
  ///
  /// Generic Status Bar Icons color
  Color? _genericAppBarIconsColor;
  Color? get genericAppBarIconsColor => _genericAppBarIconsColor;
  ///
  /// Un Selected Tab Label Color
  Color? _unselectedTabLabelColor;
  Color? get unselectedTabLabelColor => _unselectedTabLabelColor;
  ///
  /// Selected Item Text Color:
  Color? _selectedItemTextColor;
  Color? get selectedItemTextColor => _selectedItemTextColor;
  ///
  /// Un-Selected Item Text Color:
  Color? _unSelectedItemTextColor;
  Color? get unSelectedItemTextColor => _unSelectedItemTextColor;
  ///
  /// Selected Item Background Color:
  Color? _selectedItemBackgroundColor;
  Color? get selectedItemBackgroundColor => _selectedItemBackgroundColor;
  ///
  /// Un-Selected Item Background Color:
  Color? _unSelectedItemBackgroundColor;
  Color? get unSelectedItemBackgroundColor => _unSelectedItemBackgroundColor;
  ///
  /// SliverAppBar Background Color
  Color? _sliverAppBarBackgroundColor;
  Color? get sliverAppBarBackgroundColor => _sliverAppBarBackgroundColor;
  ///
  /// Background Color
  Color? _backgroundColor;
  Color? get backgroundColor => _backgroundColor;
  ///
  /// Divider Color
  Color? _dividerColor;
  Color? get dividerColor => _dividerColor;
  ///
  /// Card Color
  Color? _cardColor;
  Color? get cardColor => _cardColor;
  ///
  /// Hint Color
  Color? _hintColor;
  Color? get hintColor => _hintColor;
  ///
  /// Search Bar Background color
  Color? _searchBar02BackgroundColor;
  Color? get searchBar02BackgroundColor => _searchBar02BackgroundColor;
  ///
  /// Featured Tag Background color
  Color? _featuredTagBackgroundColor;
  Color? get featuredTagBackgroundColor => _featuredTagBackgroundColor;
  ///
  /// Featured Tag Border color
  Color? _featuredTagBorderColor;
  Color? get featuredTagBorderColor => _featuredTagBorderColor;
  ///
  /// Tag Background color
  Color? _tagBackgroundColor;
  Color? get tagBackgroundColor => _tagBackgroundColor;
  ///
  /// Tag Border color
  Color? _tagBorderColor;
  Color? get tagBorderColor => _tagBorderColor;
  ///
  /// Property Details Page Top bar Icons color
  Color? _propertyDetailsPageTopBarIconsColor;
  Color? get propertyDetailsPageTopBarIconsColor => _propertyDetailsPageTopBarIconsColor;
  ///
  /// Property Details Page Top bar Icons Background color
  Color? _propertyDetailsPageTopBarIconsBackgroundColor;
  Color? get propertyDetailsPageTopBarIconsBackgroundColor => _propertyDetailsPageTopBarIconsBackgroundColor;
  ///
  /// Circular Gauge Background color
  Color? _circularGuageBackgroundColor;
  Color? get circularGuageBackgroundColor => _circularGuageBackgroundColor;
  ///
  /// Bottom Nav Bar Background Color
  Color? _bottomNavBarBackgroundColor;
  Color? get bottomNavBarBackgroundColor => _bottomNavBarBackgroundColor;
  ///
  /// Recent Searches Border Color
  Color? _cupertinoSegmentThumbColor;
  Color? get cupertinoSegmentThumbColor => _cupertinoSegmentThumbColor;
  ///
  /// Bottom Sheet Bg Color
  Color? _bottomSheetBgColor;
  Color? get bottomSheetBgColor => _bottomSheetBgColor;
  ///
  /// Choice Chips Bg Color
  Color? _choiceChipsBgColor;
  Color? get choiceChipsBgColor => _choiceChipsBgColor;
  ///
  /// Pop Up Menu Bg Color
  Color? _popUpMenuBgColor;
  Color? get popUpMenuBgColor => _popUpMenuBgColor;
  ///
  /// Dropdown Menu Bg Color
  Color? _dropdownMenuBgColor;
  Color? get dropdownMenuBgColor => _dropdownMenuBgColor;
  ///
  /// Notification Widget Bg Color
  Color? _notificationWidgetBgColor;
  Color? get notificationWidgetBgColor => _notificationWidgetBgColor;
  ///
  /// Bottom Navigation Bar Selected Item Color.
  Color? _bottomNavigationBarSelectedItemColor;
  Color? get bottomNavigationBarSelectedItemColor => _bottomNavigationBarSelectedItemColor;
  ///
  /// Bottom Navigation Bar Unselected Item Color.
  Color? _bottomNavigationBarUnSelectedItemColor;
  Color? get bottomNavigationBarUnSelectedItemColor => _bottomNavigationBarUnSelectedItemColor;

  ///
  ///
  /// Icon:
  ///
  ///
  /// Voltage Icon
  Icon? _voltageIcon;
  Icon? get voltageIcon => _voltageIcon;
  ///
  /// Temprature Icon
  Icon? _tempratureIcon;
  Icon? get tempratureIcon => _tempratureIcon;
  ///
  /// Battery Health Icon
  Icon? _healthAndSafeIcon;
  Icon? get healthAndSafeIcon => _healthAndSafeIcon;
  ///
  /// Power Icon
  Icon? _powerIcon;
  Icon? get powerIcon => _powerIcon;
  ///
  /// Screen Time Icon
  Icon? _screenTimeIcon;
  Icon? get screenTimeIcon => _screenTimeIcon;
  ///
  /// Back Button ICon
  Icon? _genericBackButtonIcon;
  Icon? get genericBackButtonIcon => _genericBackButtonIcon;
  ///
  /// Arrow Icon
  Icon? _requestPermissionIcon;
  Icon? get requestPermissionIcon => _requestPermissionIcon;
  ///
  /// Refresh Icon
  Icon? _refreshIcon;
  Icon? get refreshIcon => _refreshIcon;
  ///
  /// Checked Icon
  Icon? _checkIcon;
  Icon? get checkIcon => _checkIcon;
  ///
  /// Close Icon
  Icon? _closeIcon;
  Icon? get closeIcon => _closeIcon;

  ///
  ///
  /// IconData:
  ///
  ///


  ///
  ///
  /// Images:
  ///
  ///
  /// Image Name
  // Image? _demoImage;
  // Image? get demoImage => _demoImage;

  ///
  ///
  /// Images Path:
  ///
  ///
  /// Apple Icon Image Path
  // String? _demoImagePath;
  // String? get demoImagePath => _demoImagePath;
}
///
///

MaterialColor primaryColorSwatch = UtilityMethods.getMaterialColor("#FF25ADDE");
MaterialColor secondaryColorSwatch = UtilityMethods.getMaterialColor("#FF25ADDE");

