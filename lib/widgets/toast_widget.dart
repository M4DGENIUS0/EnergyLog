import 'package:app/file/app_preferences/app_preferences.dart';
import 'package:app/widgets/generic_text_widget.dart';
import 'package:flutter/material.dart';



void ShowToastWidget({
  required BuildContext buildContext,
  int toastDuration = 2, // in seconds
  required String text,
  bool showButton = false,
  String buttonText = 'Button',
  Function()? onButtonPressed,
  SnackBarBehavior behavior = SnackBarBehavior.floating,
  double bottomNavBarHeight = 80,
}){
  final snackBar = SnackBar(
    content: SnackBarContentWidget(
      text: text,
      showButton: showButton,
      buttonLabel: buttonText,
      onButtonPressed: onButtonPressed,
    ),
    duration: Duration(seconds: toastDuration),
    behavior: behavior,
    backgroundColor: AppThemePreferences.toastBackgroundColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5.0),
    ),
    margin: behavior == SnackBarBehavior.floating
        ?  EdgeInsets.only(
        bottom: bottomNavBarHeight + 8.0,
        left: 16.0, right: 8.0)
        : null,
    // dismissDirection: DismissDirection.up,


  );

  ScaffoldMessenger.of(buildContext).showSnackBar(snackBar);
}

class SnackBarContentWidget extends StatelessWidget {
  final String text;
  final bool? showButton;
  final String? buttonLabel;
  final VoidCallback? onButtonPressed;

  const SnackBarContentWidget({
    Key? key,
    required this.text,
    this.showButton = false,
    this.buttonLabel = "Button",
    this.onButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return showButton!
        ? Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          flex: 2,
          child: GenericTextWidget(
            text,
            style: AppThemePreferences().appTheme.toastTextTextStyle,
            textAlign: TextAlign.start,
          ),
        ),
        Expanded(
          flex: 1,
          child: SizedBox(
            height: 40,
            child: ElevatedButton(
              onPressed: onButtonPressed ?? () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
              style: ElevatedButton.styleFrom(
                elevation: 0.0,
                backgroundColor: AppThemePreferences.toastButtonBackgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                  side: BorderSide(
                    width: 2,
                    color: Colors.white.withOpacity(0.4),
                  ),
                ),
              ),
              child: GenericTextWidget(
                buttonLabel!,
                style: AppThemePreferences().appTheme.toastTextTextStyle,
              ),
            ),
          ),
        ),
      ],
    )
        : Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: GenericTextWidget(
            text,
            style: AppThemePreferences().appTheme.toastTextTextStyle,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
