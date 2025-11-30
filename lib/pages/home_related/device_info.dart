import 'dart:io';
import 'package:app/file/app_preferences/app_preferences.dart';
import 'package:app/file/common/constants.dart';
import 'package:app/widgets/generic_text_widget.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  @override
  void initState() {
    super.initState();
    _initPlatformState();
  }

  Future<void> _initPlatformState() async {
    var deviceData = <String, dynamic>{};

    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        deviceData = {
          'Model': build.model,
          'Brand': build.brand,
          'Device': build.device,
          'Hardware': build.hardware,
          'Manufacturer': build.manufacturer,
          'Product': build.product,
          'Android Version': build.version.release,
          'SDK Version': build.version.sdkInt.toString(),
          'ID': build.id,
        };
      }
    } catch (e) {
      deviceData = {'Error': 'Failed to get device info: $e'};
    }

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,

      child: Padding(
        padding:  EdgeInsets.only(top: 18.0),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _deviceData.length,
          itemBuilder: (context, index) {
            String key = _deviceData.keys.elementAt(index);
            String value = _deviceData[key].toString();
            return _buildInfoCard(key, value);
          },
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // color: AppThemePreferences().appTheme.containerBackgroundColor,
        color: APP_DARK_COLOR,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GenericTextWidget(
            title,
            style: TextStyle(
              fontSize: AppThemePreferences.bodyFontSize,
              fontWeight: AppThemePreferences.bodyFontWeight,
              color: isDark ? AppThemePreferences.bodyTextColorDark : AppThemePreferences.bodyTextColorLight,
            ),
          ),
          GenericTextWidget(
            value,
            style: TextStyle(
              fontSize: AppThemePreferences.titleFontSize,
              fontWeight: AppThemePreferences.titleFontWeight,
              color: isDark ? AppThemePreferences.titleTextColorDark : AppThemePreferences.titleTextColorLight,
            ),
          ),
        ],
      ),
    );
  }
}
