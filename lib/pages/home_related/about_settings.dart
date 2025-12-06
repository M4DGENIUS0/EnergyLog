import 'package:app/file/app_preferences/app_preferences.dart';
import 'package:app/file/common/constants.dart';
import 'package:app/file/generic_methods/utility_methods.dart';
import 'package:app/widgets/custom_widgets/card_widget.dart';
import 'package:app/widgets/generic_settings_row_widget.dart';
import 'package:app/widgets/generic_text_widget.dart';
import 'package:app/widgets/notifications_widgets/notification_related_widgets/notification_format.dart';
import 'package:app/widgets/settings_widget/dark_mode_setting.dart';
import 'package:app/widgets/settings_widget/language_settings.dart';
import 'package:app/widgets/settings_widget/web_page.dart';
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
    appName: UNKNOWN,
    packageName: UNKNOWN,
    version: UNKNOWN,
    buildNumber: UNKNOWN,
    buildSignature: UNKNOWN,
    installerStore: UNKNOWN,
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 100),
              AppThemePreferences().appTheme.appImagePath!,
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
                "${UtilityMethods.getLocalizedString("version")}: ${_packageInfo.version}",
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
                "${UtilityMethods.getLocalizedString("build_number")}: ${_packageInfo.buildNumber}",
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
      color: AppThemePreferences().appTheme.genericInfoCardColor,
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
                      setState(() {
                        notificationsEnabled = false;
                      });
                    }
                  } else if (status.isPermanentlyDenied) {
                    openAppSettings();
                    setState(() {
                      notificationsEnabled = false;
                    });
                  }
                } else {
                  setState(() {
                    notificationsEnabled = false;
                  });
                  HiveStorageManager.storeNotificationEnabled(false);
                }
              },
            ),
            GenericWidgetRow(
              iconData: AppThemePreferences.notificationFormat,
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
      color: AppThemePreferences().appTheme.genericInfoCardColor,
      child: GenericSettingsWidget(
        enableBottomDecoration: false,
        headingText: UtilityMethods.getLocalizedString("preference"),
        headingSubTitleText: UtilityMethods.getLocalizedString(
          "customise_your_experience_on_app",
        ),
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
      color: AppThemePreferences().appTheme.genericInfoCardColor,
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
              iconData: AppThemePreferences.electricBoltIcon,
              text: UtilityMethods.getLocalizedString(
                "${UtilityMethods.getLocalizedString("power_unit")} (${isWatts ? 'W' : 'mW'})",
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
              iconData: AppThemePreferences.temperatureIcon,
              text: UtilityMethods.getLocalizedString(
                "${UtilityMethods.getLocalizedString("temperature_unit")} (${isCelsius ? '°C' : '°F'})",
              ),
              removeDecoration: true,
              switchButtonEnabled: true,
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
      color: AppThemePreferences().appTheme.genericInfoCardColor,
      child: GenericSettingsWidget(
        enableBottomDecoration: false,
        headingText: UtilityMethods.getLocalizedString("about_legal"),
        headingSubTitleText: UtilityMethods.getLocalizedString(
          "privacy_policy_description",
        ),
        removeDecoration: true,

        body: Column(
          crossAxisAlignment: .start,
          spacing: 10,
          children: [
            GenericWidgetRow(
              iconData: AppThemePreferences.policyIcon,
              text: UtilityMethods.getLocalizedString("privacy_policy"),
              removeDecoration: false,
              onTap: () => onPrivacyTap(context),
            ),
            GenericWidgetRow(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              iconData: AppThemePreferences.gravelIcon,
              text: UtilityMethods.getLocalizedString("terms_conditions"),
              removeDecoration: false,
              onTap: () => onTermsAndConditionsTap(context),
            ),
            GenericWidgetRow(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              iconData: AppThemePreferences.activitiesIcon,
              text: UtilityMethods.getLocalizedString("license"),
              removeDecoration: false,
              onTap: () => onLicenseTap(context),
            ),
            GenericWidgetRow(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              iconData: AppThemePreferences.bugReportIcon,
              text: UtilityMethods.getLocalizedString("raise_issue"),
              removeDecoration: false,
              onTap: () => onReportingBugTap(context),
            ),
            GenericWidgetRow(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              iconData: AppThemePreferences.bulbIcon,
              text: UtilityMethods.getLocalizedString("request_a_feature"),
              removeDecoration: false,
              onTap: () => onRequestingFeatureTap(context),
            ),
            GenericWidgetRow(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              iconData: AppThemePreferences.starOutlinedIcon,
              text: UtilityMethods.getLocalizedString("rate_app"),
              removeDecoration: false,
              onTap: () {},
            ),
            GenericWidgetRow(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              iconData: AppThemePreferences.shareIconOutlined,
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

  void onTermsAndConditionsTap(BuildContext context){
    UtilityMethods.navigateToRoute(
        context: context,
        builder: (context) => WebPage(DEMO_URL, UtilityMethods.getLocalizedString("terms_and_conditions")));
  }

  void onPrivacyTap(BuildContext context){
    UtilityMethods.navigateToRoute(
        context: context,
        builder: (context) => WebPage(DEMO_URL, UtilityMethods.getLocalizedString("privacy_policy")));
  }

  void onLicenseTap(BuildContext context){
    UtilityMethods.navigateToRoute(
        context: context,
        builder: (context) => WebPage(DEMO_URL, UtilityMethods.getLocalizedString("license")));
  }

  void onReportingBugTap(BuildContext context){
    UtilityMethods.navigateToRoute(
        context: context,
        builder: (context) => WebPage(DEMO_URL, UtilityMethods.getLocalizedString("raise_issue")));
  }

  void onRequestingFeatureTap(BuildContext context){
    UtilityMethods.navigateToRoute(
        context: context,
        builder: (context) => WebPage(DEMO_URL, UtilityMethods.getLocalizedString("request_a_feature"),));
  }


  void onLanguageSettingsTap(BuildContext context) {
    UtilityMethods.navigateToRoute(
      context: context,
      builder: (context) => LanguageSettings(),
    );
  }


}
