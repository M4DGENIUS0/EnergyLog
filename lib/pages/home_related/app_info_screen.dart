
import 'package:app/file/app_preferences/app_preferences.dart';
import 'package:app/file/common/constants.dart';
import 'package:app/widgets/generic_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:app/file/hive_storage_files/hive_storage_manager.dart';

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
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                color: isDark ? AppThemePreferences.headingTextColorDark : AppThemePreferences.headingTextColorLight,
              ),
            ),
            const SizedBox(height: 10),
            GenericTextWidget(
              "Version: ${_packageInfo.version}",
              style: TextStyle(
                fontSize: AppThemePreferences.bodyFontSize,
                fontWeight: AppThemePreferences.bodyFontWeight,
                color: isDark ? AppThemePreferences.bodyTextColorDark : AppThemePreferences.bodyTextColorLight,
              ),
            ),
            const SizedBox(height: 5),
            GenericTextWidget(
              "Build Number: ${_packageInfo.buildNumber}",
              style: TextStyle(
                fontSize: AppThemePreferences.subBodyFontSize,
                fontWeight: AppThemePreferences.subBodyFontWeight,
                color: isDark ? AppThemePreferences.subBodyTextColorDark : AppThemePreferences.subBodyTextColorLight,
              ),
            ),
            const SizedBox(height: 40),
            SvgPicture.asset(
              'assets/logo.svg',
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 20),
            ValueListenableBuilder(
              valueListenable: Hive.box(HIVE_BOX).listenable(keys: ['notifications_enabled']),
              builder: (context, box, widget) {
                bool notificationsEnabled = box.get('notifications_enabled', defaultValue: true);
                return SwitchListTile(
                  title: GenericTextWidget(
                    "Enable Notifications",
                    style: TextStyle(
                      fontSize: AppThemePreferences.bodyFontSize,
                      fontWeight: AppThemePreferences.bodyFontWeight,
                      color: isDark ? AppThemePreferences.bodyTextColorDark : AppThemePreferences.bodyTextColorLight,
                    ),
                  ),
                  value: notificationsEnabled,
                  onChanged: (value) {
                    box.put('notifications_enabled', value);
                  },
                );
              },
            ),
            const SizedBox(height: 10),
            ValueListenableBuilder(
              valueListenable: Hive.box(HiveStorageManager.userBoxName).listenable(keys: ['temp_unit_celsius']),
              builder: (context, box, widget) {
                bool isCelsius = box.get('temp_unit_celsius', defaultValue: true);
                return SwitchListTile(
                  title: GenericTextWidget(
                    "Temperature Unit (${isCelsius ? '°C' : '°F'})",
                    style: TextStyle(
                      fontSize: AppThemePreferences.bodyFontSize,
                      fontWeight: AppThemePreferences.bodyFontWeight,
                      color: AppThemePreferences().appTheme.bodyTextColor,
                    ),
                  ),
                  value: isCelsius,
                  onChanged: (value) {
                    box.put('temp_unit_celsius', value);
                  },
                );
              },
            ),
            const SizedBox(height: 10),
            ValueListenableBuilder(
              valueListenable: Hive.box(HiveStorageManager.userBoxName).listenable(keys: ['power_unit_watts']),
              builder: (context, box, widget) {
                bool isWatts = box.get('power_unit_watts', defaultValue: true);
                return SwitchListTile(
                  title: GenericTextWidget(
                    "Power Unit (${isWatts ? 'W' : 'mW'})",
                    style: TextStyle(
                      fontSize: AppThemePreferences.bodyFontSize,
                      fontWeight: AppThemePreferences.bodyFontWeight,
                      color: AppThemePreferences().appTheme.bodyTextColor,
                    ),
                  ),
                  value: isWatts,
                  onChanged: (value) {
                    box.put('power_unit_watts', value);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
