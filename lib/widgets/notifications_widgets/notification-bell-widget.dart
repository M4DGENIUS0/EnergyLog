import 'package:app/file/app_preferences/app_preferences.dart';
import 'package:app/file/common/constants.dart';
import 'package:app/file/generic_methods/utility_methods.dart';
import 'package:flutter/material.dart';

typedef NotificationBellWidgetListener = void Function(bool hideNotificationDot);

class NotificationBellWidget extends StatelessWidget {
  final bool showNotificationDot;
  final bool userLoggedIn;
  final NotificationBellWidgetListener listener;

  const NotificationBellWidget({
    super.key,
    required this.showNotificationDot,
    required this.userLoggedIn,
    required this.listener,
  });

  @override
  Widget build(BuildContext context) {
    if (!SHOW_NOTIFICATIONS) {
      return Container(padding: const EdgeInsets.symmetric(vertical: 20));
    }
    return Stack(
      children: [
        Center(
          child: GestureDetector(
            onTap: ()=> onNotificationBellTap(context),
            child: Container(
              width: 40,
              height: 40,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(50)),
                child: Container(
                  color: AppThemePreferences().appTheme.searchBar02BackgroundColor,
                  child: Icon(
                    AppThemePreferences.notificationIcon,
                  ),
                ),
              ),
            ),
          ),
        ),
        if (showNotificationDot) Positioned(
          top: 0,
          bottom: 28,
          left: UtilityMethods.isRTL(context) ? 0 : 28,
          right: UtilityMethods.isRTL(context) ? 28 : 0,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(50)),
            child: Container(
              alignment: Alignment.center,
              color: AppThemePreferences.notificationDotColor,
            ),
          ),
        ),
      ],
    );
  }

  void onNotificationBellTap(BuildContext context) {
    if (userLoggedIn) {
    //   listener(true);
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => const AllNotificationsPage(),
    //     ),
    //   );
    } else {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => UserSignIn((String closeOption) {
      //         if (closeOption == CLOSE) {
      //           Navigator.pop(context);
      //         }
      //       },
      //     ),
      //   ),
      // );
    }
  }
}