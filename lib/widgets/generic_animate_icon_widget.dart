import 'package:animate_icons/animate_icons.dart';
import 'package:app/file/app_preferences/app_preferences.dart';
import 'package:flutter/material.dart';

AnimateIcons GenericAnimateIcons({
  required IconData startIcon,
  required IconData endIcon,
  required bool Function() onStartIconPress,
  required bool Function() onEndIconPress,
  double? size,
  required AnimateIconController controller,
  Color? startIconColor,
  Color? endIconColor,
  Duration? duration,
  bool? clockwise,
  String? startTooltip,
  String? endTooltip,
}){
  return AnimateIcons(
    startIcon: startIcon,
    endIcon: endIcon,
    onStartIconPress: onStartIconPress,
    onEndIconPress: onEndIconPress,
    size: size,
    controller: controller,
    startIconColor: startIconColor ?? AppThemePreferences().appTheme.iconsColor,
    endIconColor: endIconColor ?? AppThemePreferences().appTheme.iconsColor,
    duration: duration ?? const Duration(milliseconds: 500),
    clockwise: clockwise,
    startTooltip: startTooltip,
    endTooltip: endTooltip,
  );
}