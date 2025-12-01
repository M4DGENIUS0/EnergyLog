import 'package:app/file/app_preferences/app_preferences.dart';
import 'package:app/file/common/constants.dart';
import 'package:app/file/generic_methods/utility_methods.dart';
import 'package:app/widgets/custom_widgets/card_widget.dart';
import 'package:app/widgets/generic_settings_row_widget.dart';
import 'package:app/widgets/generic_text_widget.dart';
import 'package:app/widgets/notifications_widgets/notification_related_widgets/notification_format.dart';
import 'package:app/widgets/settings_widget/dark_mode_setting.dart';
import 'package:app/widgets/settings_widget/language_settings.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:app/file/hive_storage_files/hive_storage_manager.dart';
import 'package:permission_handler/permission_handler.dart';

class AppInfoScreen extends StatefulWidget {
  const AppInfoScreen({super.key});

  @override
  State<AppInfoScreen> createState() => _AppInfoScreenState();
}

class _AppInfoScreenState extends State<AppInfoScreen> {
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  bool notificationsEnabled =
      HiveStorageManager.readNotificationEnabled() ?? false;
  bool isCelsius = HiveStorageManager.readChangeTempretureUnit() ?? false;
  bool isWatts = HiveStorageManager.readPowerUnit() ?? false;

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return SafeArea(
      top: true,
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 100),
              Icon(
                Icons.info_outline,
                size: 80,
                color: AppThemePreferences().appTheme.primaryColor,
              ),
              const SizedBox(height: 20),
              GenericTextWidget(
                _packageInfo.appName,
                style: TextStyle(
                  fontSize: AppThemePreferences.headingFontSize,
                  fontWeight: AppThemePreferences.headingFontWeight,
                  color: isDark
                      ? AppThemePreferences.headingTextColorDark
                      : AppThemePreferences.headingTextColorLight,
                ),
              ),
              const SizedBox(height: 10),
              GenericTextWidget(
                "Version: ${_packageInfo.version}",
                style: TextStyle(
                  fontSize: AppThemePreferences.bodyFontSize,
                  fontWeight: AppThemePreferences.bodyFontWeight,
                  color: isDark
                      ? AppThemePreferences.bodyTextColorDark
                      : AppThemePreferences.bodyTextColorLight,
                ),
              ),
              const SizedBox(height: 5),
              GenericTextWidget(
                "Build Number: ${_packageInfo.buildNumber}",
                style: TextStyle(
                  fontSize: AppThemePreferences.subBodyFontSize,
                  fontWeight: AppThemePreferences.subBodyFontWeight,
                  color: isDark
                      ? AppThemePreferences.subBodyTextColorDark
                      : AppThemePreferences.subBodyTextColorLight,
                ),
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.only(top: 20.0),
                child: Column(
                  children: [
                    appNotificationCard(),
                    Container(height: 20.0),
                    appThemeCard(),
                    Container(height: 20.0),
                    appStanderdCard(),
                    Container(height: 20.0),
                    appStanderdCard(),
                    Container(height: 20.0),
                    appAboutLegalCard(),
                    Container(height: 40.0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Card Regarding Notification!
  Widget appNotificationCard() {
    return CardWidget(
      shape: AppThemePreferences.roundedCorners(
        AppThemePreferences.globalRoundedCornersRadius,
      ),
      color: APP_DARK_COLOR,
      child: GenericSettingsWidget(
        headingText: UtilityMethods.getLocalizedString("Notifications"),
        headingSubTitleText: UtilityMethods.getLocalizedString(
          "notification_format_description",
        ),
        removeDecoration: true,
        body: Column(
          crossAxisAlignment: .start,

          children: [
            GenericWidgetRow(
              iconData: AppThemePreferences.notificationIcon,
              text: UtilityMethods.getLocalizedString("enable_notification"),
              removeDecoration: false,
              switchButtonEnabled: true,
              switchButtonValue: notificationsEnabled,
              onTapSwitch: (v) async {
                if (v) {
                  var status = await Permission.notification.status;
                  if (status.isGranted) {
                    setState(() {
                      notificationsEnabled = true;
                    });
                    HiveStorageManager.storeNotificationEnabled(true);
                  } else if (status.isDenied) {
                    var result = await Permission.notification.request();
                    if (result.isGranted) {
                      setState(() {
                        notificationsEnabled = true;
                      });
                      HiveStorageManager.storeNotificationEnabled(true);
                    } else {
                      // Permission denied, keep switch off
                      setState(() {
                        notificationsEnabled = false;
                      });
                    }
                  } else if (status.isPermanentlyDenied) {
                    // Open settings if permanently denied
                    openAppSettings();
                    setState(() {
                      notificationsEnabled = false;
                    });
                  }
                } else {
                  // User wants to disable notifications
                  setState(() {
                    notificationsEnabled = false;
                  });
                  HiveStorageManager.storeNotificationEnabled(false);
                }
              },
            ),
            GenericWidgetRow(
              iconData: AppThemePreferences.darkModeIcon,
              text: UtilityMethods.getLocalizedString("notification_format"),
              removeDecoration: true,
              onTap: () => onNotificationSettingsTap(context),
            ),
          ],
        ),
      ),
    );
  }

  /// Card Regarding Theme
  Widget appThemeCard() {
    return CardWidget(
      shape: AppThemePreferences.roundedCorners(
        AppThemePreferences.globalRoundedCornersRadius,
      ),
      color: APP_DARK_COLOR,
      child: GenericSettingsWidget(
        enableBottomDecoration: false,
        headingText: UtilityMethods.getLocalizedString("preference"),
        headingSubTitleText: UtilityMethods.getLocalizedString(
          "customise_your_experience_on_app",
        ),
        // headingSubTitleText: AppLocalizations.of(context).customise_your_experience_on_app(appName),
        removeDecoration: true,

        body: Column(
          crossAxisAlignment: .start,
          children: [
            GenericWidgetRow(
              iconData: AppThemePreferences.darkModeIcon,
              text: UtilityMethods.getLocalizedString("dark_mode"),
              removeDecoration: false,
              onTap: () => onDarkModeSettingsTap(context),
            ),
            GenericWidgetRow(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              iconData: AppThemePreferences.languageIcon,
              text: UtilityMethods.getLocalizedString("language_label"),
              removeDecoration: true,
              onTap: () => onLanguageSettingsTap(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget appStanderdCard() {
    return CardWidget(
      shape: AppThemePreferences.roundedCorners(
        AppThemePreferences.globalRoundedCornersRadius,
      ),
      color: APP_DARK_COLOR,
      child: GenericSettingsWidget(
        headingText: UtilityMethods.getLocalizedString("standerd"),
        headingSubTitleText: UtilityMethods.getLocalizedString(
          "standerd_description",
        ),
        removeDecoration: true,
        body: Column(
          crossAxisAlignment: .start,

          children: [
            GenericWidgetRow(
              // iconData: AppThemePreferences.notificationIcon,
              iconData: Icons.electric_bolt,
              text: UtilityMethods.getLocalizedString(
                "Power Unit (${isWatts ? 'W' : 'mW'})",
              ),
              switchButtonEnabled: true,
              // switchButtonText: ,
              switchButtonValue: isWatts,
              onTapSwitch: (v) {
                setState(() {
                  isWatts = v;
                });
                HiveStorageManager.storePowerUnit(v);
              },
            ),

            GenericWidgetRow(
              // iconData: AppThemePreferences.notificationIcon,
              iconData: Icons.thermostat,
              text: UtilityMethods.getLocalizedString(
                "Temperature Unit (${isCelsius ? '°C' : '°F'})",
              ),
              removeDecoration: true,
              switchButtonEnabled: true,
              // switchButtonText: ,
              switchButtonValue: isCelsius,
              onTapSwitch: (v) {
                setState(() {
                  isCelsius = v;
                });
                HiveStorageManager.storeChangeTempretureUnit(v);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget appAboutLegalCard() {
    return CardWidget(
      shape: AppThemePreferences.roundedCorners(
        AppThemePreferences.globalRoundedCornersRadius,
      ),
      color: APP_DARK_COLOR,
      child: GenericSettingsWidget(
        enableBottomDecoration: false,
        headingText: UtilityMethods.getLocalizedString("about_legal"),
        headingSubTitleText: UtilityMethods.getLocalizedString(
          "View the privacy policy, terms of service, and version info.",
        ),
        // headingSubTitleText: AppLocalizations.of(context).customise_your_experience_on_app(appName),
        removeDecoration: true,

        body: Column(
          crossAxisAlignment: .start,
          spacing: 10,
          children: [
            GenericWidgetRow(
              iconData: Icons.privacy_tip,
              text: UtilityMethods.getLocalizedString("privacy_policy"),
              removeDecoration: false,
              onTap: () {},
            ),
            GenericWidgetRow(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              iconData: Icons.description,
              text: UtilityMethods.getLocalizedString("terms_conditions"),
              removeDecoration: false,
              onTap: () {},
            ),
            GenericWidgetRow(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              iconData: Icons.article,
              text: UtilityMethods.getLocalizedString("license"),
              removeDecoration: false,
              onTap: () {},
            ),
            GenericWidgetRow(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              iconData: Icons.bug_report,
              text: UtilityMethods.getLocalizedString("raise_issue"),
              removeDecoration: false,
              onTap: () {},
            ),
            GenericWidgetRow(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              iconData: Icons.lightbulb,
              text: UtilityMethods.getLocalizedString("request_a_feature"),
              removeDecoration: false,
              onTap: () {},
            ),
            GenericWidgetRow(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              iconData: Icons.star,
              text: UtilityMethods.getLocalizedString("rate_app"),
              removeDecoration: false,
              onTap: () {},
            ),
            GenericWidgetRow(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              iconData: Icons.share,
              text: UtilityMethods.getLocalizedString("share_app"),
              removeDecoration: true,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  void onNotificationSettingsTap(BuildContext context) {
    UtilityMethods.navigateToRoute(
      context: context,
      builder: (context) => NotificationFormatSettings(),
    );
  }

  void onDarkModeSettingsTap(BuildContext context) {
    UtilityMethods.navigateToRoute(
      context: context,
      builder: (context) => DarkModeSettings(),
    );
  }

  void onLanguageSettingsTap(BuildContext context) {
    UtilityMethods.navigateToRoute(
      context: context,
      builder: (context) => LanguageSettings(),
    );
  }

  void onEditProfileTap(BuildContext context) {
    // UtilityMethods.navigateToRoute(
    //   context: context,
    //   builder: (context) {
    //
    //   },
    // );
  }

  void onPropertiesTap(BuildContext context) {
    // isUserLogged
    //     ? UtilityMethods.navigateToRoute(
    //   context: context,
    //   builder: (context) => Properties(),
    // )
    //     : onLogInTap(context);
  }

  void onAddPropertyTap(BuildContext context) {
    // isUserLogged
    //     ? UtilityMethods.navigateToRoute(
    //   context: context,
    //   builder: (context) {
    //     return UtilityMethods.navigateToAddPropertyPage();
    //   },
    //   // builder: (context) => AddPropertyV2(),
    //   // builder: (context) => AddProperty(),
    // )
    // : onLogInTap(context);
  }

  void onAllUsersTap(BuildContext context) {
    // UtilityMethods.navigateToRoute(
    //   context: context,
    //   builder: (context) => AllUsers(),
    // );
  }

  void onAllReviewsTap(BuildContext context) {
    // UtilityMethods.navigateToRoute(
    //   context: context,
    //   builder: (context) => AllReviews(fromProperty: false,),
    // );
  }

  void onInsightsTap(BuildContext context) {
    // UtilityMethods.navigateToRoute(
    //   context: context,
    //   builder: (context) => Insights(),
    // );
  }

  void onSettingsTap(BuildContext context) {
    // UtilityMethods.navigateToRoute(
    //   context: context,
    //   builder: (context) => HomePageSettings(),
    // );
  }

  void onRequestDemoTap(BuildContext context) {
    // UtilityMethods.navigateToRoute(
    //   context: context,
    //   builder: (context) => ContactDeveloper(),
    // );
  }

  onLogInTap(BuildContext context) {
    // UtilityMethods.navigateToRoute(
    //   context: context,
    //   builder: (context) => UserSignIn(
    //         (String closeOption) {
    //       if (closeOption == CLOSE) {
    //         Navigator.pop(context);
    //       }
    //     },
    //   ),
    // );
  }
}
