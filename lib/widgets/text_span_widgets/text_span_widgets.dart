import 'package:app/file/app_preferences/app_preferences.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

TextSpan GenericNormalTextSpanWidget({
  required String text,
  List<InlineSpan>? children,
  Function()? onTap,
}){
  return TextSpan(
    text: text,
    style: AppThemePreferences().appTheme.bodyTextStyle,
    recognizer: TapGestureRecognizer()..onTap = onTap,
  );
}

TextSpan GenericLinkTextSpanWidget({
  required String text,
  Function()? onTap,
  List<InlineSpan>? children,
}){
  return TextSpan(
    text: text,
    style: AppThemePreferences().appTheme.linkTextStyle,
    recognizer: TapGestureRecognizer()..onTap = onTap,
    children: children,
  );
}