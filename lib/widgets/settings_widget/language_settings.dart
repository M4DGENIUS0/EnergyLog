import 'package:app/file/app_preferences/app_preferences.dart';
import 'package:app/file/generic_methods/general_notifier.dart';
import 'package:app/file/generic_methods/utility_methods.dart';
import 'package:app/file/hive_storage_files/hive_storage_manager.dart';
import 'package:app/file/hooks_files/hooks_configurations.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/pages/parent_home.dart';
import 'package:app/providers/state_providers/locale_provider.dart';
import 'package:app/widgets/app_bar_widget.dart';
import 'package:app/widgets/generic_radio_list_tile.dart';
import 'package:app/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LanguageSettings extends StatefulWidget{
  final bool? showBackButton;

  const LanguageSettings({
    super.key,
    this.showBackButton = true,
  });

  @override
  State<StatefulWidget> createState() => LanguageSettingsState();
}

class LanguageSettingsState extends State<LanguageSettings> {

  Locale? locale;
  LocaleProvider? provider;

  List list = [];
  String? _selectedLanguage;


  @override
  void initState() {
    DefaultLanguageCodeHook defaultLanguageCodeHook = HooksConfigurations.defaultLanguageCode;
    // String defaultLanguage = defaultLanguageCodeHook().isEmpty ? "en" : defaultLanguageCodeHook();
    String defaultLanguage = defaultLanguageCodeHook();
    Locale localeFromStorage = HiveStorageManager.readLanguageSelectionLocale() ?? Locale(defaultLanguage);

    final tempFlag = L10n.getLanguageName(localeFromStorage);
    _selectedLanguage = tempFlag;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<LocaleProvider>(context);

    return Scaffold(
      appBar: AppBarWidget(
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        appBarTitle: UtilityMethods.getLocalizedString("language_label"),
        automaticallyImplyLeading: widget.showBackButton != null && widget.showBackButton! ? true : false,
      ),
      body: Column(
        children: [
          LanguageSettingsHeadingWidget(),
          Expanded(
            child: LanguageSelectionWidget(
              selectedLanguage: _selectedLanguage!,
              listener: (selectedLanguage, locale) {
                if(mounted) {
                  setState(() {
                    _selectedLanguage = selectedLanguage;
                  });
                }
                provider = Provider.of<LocaleProvider>(context, listen: false);
                provider!.setLocale(locale);
                GeneralNotifier().publishChange(GeneralNotifier.CHANGE_LOCALIZATION);
                UtilityMethods.navigateToRouteByPushAndRemoveUntil(context: context, builder: (context) => const ParentHome());
              },
            ),
          ),
        ],
      ),
    );
  }
}

class LanguageSettingsHeadingWidget extends StatelessWidget {
  const LanguageSettingsHeadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return HeaderWidget(
      text: UtilityMethods.getLocalizedString("select_language"),
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

typedef LanguageSelectionWidgetListener = void Function(String selectedLanguage, Locale locale);
class LanguageSelectionWidget extends StatelessWidget {
  final String selectedLanguage;
  final LanguageSelectionWidgetListener listener;

  const LanguageSelectionWidget({
    super.key,
    required this.selectedLanguage,
    required this.listener,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: L10n.all.map((locale) {
          final flag = L10n.getLanguageName(locale);
          return GenericRadioListTile(
            title: flag,
            value: flag,
            groupValue: selectedLanguage,
            onChanged: (value) => listener(value, locale),
          );
        }).toList(),
      ),
    );
  }
}
