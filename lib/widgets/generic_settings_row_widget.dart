import 'package:app/file/app_preferences/app_preferences.dart';
import 'package:app/file/common/constants.dart';
import 'package:app/widgets/generic_text_widget.dart';
import 'package:flutter/material.dart';

class GenericWidgetRow extends StatelessWidget {
  final IconData iconData;
  final String text;
  final String? subText;
  final String? switchButtonText;
  final void Function()? onTap;
  final bool? removeDecoration;
  final bool switchButtonEnabled;
  final bool? switchButtonValue;
  final bool? showArrowTrail;
  final EdgeInsetsGeometry? padding;
  final double? iconSize;
  final double? fontSize;
  final void Function(bool)? onTapSwitch;

  GenericWidgetRow({
    Key? key,
    required this.iconData,
    required this.text,
    this.onTap,
    this.switchButtonText = "",
    this.padding = const EdgeInsets.only(top: 20.0, bottom: 10.0),
    this.removeDecoration = false,
    this.iconSize,
    this.switchButtonValue = false,
    this.switchButtonEnabled = false,
    this.showArrowTrail = true,
    this.subText,
    this.fontSize,
    this.onTapSwitch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: (removeDecoration ?? false)
          ? null
          : AppThemePreferences.dividerDecoration(),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: padding,
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      iconData,
                      color: AppThemePreferences().appTheme.primaryColor,
                      size: iconSize ?? AppThemePreferences.settingsIconSize,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: GenericTextWidget(
                        text,
                        style: AppThemePreferences()
                            .appTheme
                            .settingOptionsTextStyle!
                            .copyWith(
                          fontSize: fontSize ??
                              AppThemePreferences.settingOptionsTextFontSize,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// Subtext on right (if available)
              (subText != null && subText!.isNotEmpty)
                  ? Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: GenericTextWidget(
                  subText!,
                  style: AppThemePreferences()
                      .appTheme
                      .settingOptionsTextStyle!
                      .copyWith(
                    fontSize: fontSize ??
                        AppThemePreferences.settingOptionsTextFontSize,
                  ),
                ),
              )
                  : SizedBox.shrink(),

              /// Inline Switch
              if (switchButtonEnabled)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (switchButtonText!.isNotEmpty)
                      GenericTextWidget(
                        switchButtonText!,
                        style: TextStyle(
                          fontSize: AppThemePreferences.bodyFontSize,
                          fontWeight: AppThemePreferences.bodyFontWeight,
                          color: AppThemePreferences().appTheme.bodyTextColor,
                        ),
                      ),
                    Switch(
                      value: switchButtonValue!,
                      onChanged: onTapSwitch,
                      activeTrackColor: AppThemePreferences().appTheme.primaryColor,
                      activeThumbColor: Colors.white,
                    ),
                  ],
                ),
              if (showArrowTrail != null && !switchButtonEnabled)
                Icon(
                  Icons.arrow_forward_ios,
                  // color: AppThemePreferences().appTheme.primaryColor,
                  // color: APP_DARK_COLOR, // Card color dont use this
                  color: Colors.white54, /// Good it will use for dark color
                  size: 14, // Size is good dont change it
                )
            ],
          ),
        ),
      ),
    );
  }
}

class GenericSettingsWidget extends StatelessWidget {
  final String headingText;
  final String? headingSubTitleText;
  final Widget body;
  final bool removeDecoration;
  final bool enableTopDecoration;
  final bool enableBottomDecoration;

  const GenericSettingsWidget({
    Key? key,
    required this.headingText,
    required this.body,
    this.headingSubTitleText,
    this.removeDecoration = false,
    this.enableTopDecoration = false,
    this.enableBottomDecoration = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: removeDecoration
          ? null
          : AppThemePreferences.dividerDecoration(
        bottom: enableBottomDecoration,
        top: enableTopDecoration,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadingWidget(text: headingText),
          if (headingSubTitleText != null &&
              headingSubTitleText!.isNotEmpty)
            HeadingSubTitleWidget(text: headingSubTitleText!),
          body,
        ],
      ),
    );
  }
}

class HeadingWidget extends StatelessWidget {
  final String text;

  const HeadingWidget({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GenericTextWidget(
      text,
      style: AppThemePreferences()
          .appTheme
          .settingHeadingTextStyle!
          .copyWith(color: Colors.white),
      strutStyle: StrutStyle(height: AppThemePreferences.genericTextHeight),
    );
  }
}

class HeadingSubTitleWidget extends StatelessWidget {
  final String text;

  const HeadingSubTitleWidget({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 3),
      child: GenericTextWidget(
        text,
        style: AppThemePreferences()
            .appTheme
            .settingHeadingSubTitleTextStyle!
            .copyWith(color: Colors.white),
        strutStyle: StrutStyle(height: AppThemePreferences.genericTextHeight),
      ),
    );
  }
}