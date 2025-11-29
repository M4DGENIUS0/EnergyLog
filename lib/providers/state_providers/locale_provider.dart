import 'package:app/file/hive_storage_files/hive_storage_manager.dart';
import 'package:app/file/hooks_files/hooks_configurations.dart';
import 'package:app/l10n/l10n.dart';
import 'package:flutter/material.dart';


class LocaleProvider extends ChangeNotifier {

  Locale? _locale;
  Locale? get locale => _locale;

  static LocaleProvider? _localeProvider;

  factory LocaleProvider() {
    _localeProvider ??= LocaleProvider._internal();
    return _localeProvider!;
  }

  LocaleProvider._internal(){
    DefaultLanguageCodeHook defaultLanguageCodeHook = HooksConfigurations.defaultLanguageCode;
    String defaultLanguage = defaultLanguageCodeHook();


    _locale = HiveStorageManager.readLanguageSelectionLocale() ?? Locale(defaultLanguage);
    HiveStorageManager.storeLanguageSelection(locale: _locale!);
    notifyListeners();
  }

  void setLocale(Locale locale) {
    if (!L10n.getAllLanguagesLocale().contains(locale)) return;
    _locale = locale;
    HiveStorageManager.storeLanguageSelection(locale: _locale!);
    notifyListeners();
  }
}
