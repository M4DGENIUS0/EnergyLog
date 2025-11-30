import 'package:app/file/app_preferences/app_preferences.dart';
import 'package:app/file/common/constants.dart';
import 'package:app/file/generic_methods/general_notifier.dart';
import 'package:app/file/generic_methods/utility_methods.dart';
import 'package:app/file/hive_storage_files/hive_storage_manager.dart';
import 'package:app/file/hooks_files/hooks_configurations.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/pages/parent_home.dart';
import 'package:app/providers/state_providers/locale_provider.dart';
import 'package:app/widgets/app_bar_widget.dart';
import 'package:app/widgets/generic_multi_selector.dart';
import 'package:app/widgets/generic_radio_list_tile.dart';
import 'package:app/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationFormatSettings extends StatefulWidget{
  final bool? showBackButton;

  const NotificationFormatSettings({
    super.key,
    this.showBackButton = true,
  });

  @override
  State<StatefulWidget> createState() => NotificationFormatSettingsState();
}

class NotificationFormatSettingsState extends State<NotificationFormatSettings> {

  Locale? locale;
  LocaleProvider? provider;
  List<String> selectedNotifications = [];
  List<String> notificationList = [];
  String? _selectedLanguage;
    DefaultSelectedNotificationsFormatsHook selectedNotification = HooksConfigurations.defaultSelectedNotificationsFormatsHook;
    AvailableNotificationsFormatsHook allNotificationList = HooksConfigurations.availableNotificationsFormatsHook;


  @override
  void initState() {
    final preSelectedHook = HooksConfigurations.defaultSelectedNotificationsFormatsHook;
    final availableHook = HooksConfigurations.availableNotificationsFormatsHook;

    selectedNotifications = preSelectedHook?.call() ?? [];
    notificationList = availableHook?.call() ?? [];
    print("Selected Notifications: $selectedNotifications");
    print("Available Notifications: $notificationList");

    // String defaultLanguage = defaultLanguageCodeHook().isEmpty ? "en" : defaultLanguageCodeHook();
  //   String defaultLanguage = defaultLanguageCodeHook();
  //   Locale localeFromStorage = HiveStorageManager.readLanguageSelectionLocale() ?? Locale(defaultLanguage);
  //
  //   final tempFlag = L10n.getLanguageName(localeFromStorage);
  //   _selectedLanguage = tempFlag;
  //   super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // provider = Provider.of<LocaleProvider>(context);

    return Scaffold(
      appBar: AppBarWidget(
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        appBarTitle: UtilityMethods.getLocalizedString("notification_format"),
        automaticallyImplyLeading: widget.showBackButton != null && widget.showBackButton! ? true : false,
        actions: [IconButton(
          icon: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color:
                // AppThemePreferences()
                //     .appTheme
                //     .genericAppBarIconsColor ??
                // Colors.black,
                // Colors.white54,
                APP_DARK_COLOR,
                width: 1,
              ),
            ),
            padding: const EdgeInsets.all(8),
            child: Icon(AppThemePreferences.checkIcon, size: 20),
          ),
          color: AppThemePreferences().appTheme.genericAppBarIconsColor,
          onPressed: () => onDonePressedFunc(),
        )],
      ),
      body: Column(
        children: [
          NotificationFormatSettingsHeadingWidget(),
          Expanded(
            child: GenericMultiSelectWidget(selectedDataList: selectedNotifications, dataList: notificationList, listener: (v){
              print("Show Selected Notifications: $v");
            },),
          ),
        ],
      ),
    );
  }

  onDonePressedFunc(){

  }
}

class NotificationFormatSettingsHeadingWidget extends StatelessWidget {
  const NotificationFormatSettingsHeadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return HeaderWidget(
      text: UtilityMethods.getLocalizedString("notification_format_description"),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      alignment: Alignment.topLeft,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppThemePreferences().appTheme.dividerColor!),
        ),
      ),
    );
  }
}

