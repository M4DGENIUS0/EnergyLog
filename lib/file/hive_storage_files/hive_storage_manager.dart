import 'package:app/file/common/constants.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveStorageManager {
  static Box hiveBox = Hive.box(HIVE_BOX);
  static String get userBoxName => HIVE_BOX;

  static Future<void> openHiveBox() async {
    WidgetsFlutterBinding.ensureInitialized();
    print("Initializing Hive...");
    await Hive.initFlutter();
    print("Checking for old Box...");
    bool isBoxExists = await Hive.boxExists(HIVE_BOX_OLD);
    if (isBoxExists) {
      print("Box: $HIVE_BOX_OLD exists");
      await Hive.deleteBoxFromDisk(HIVE_BOX_OLD);
    }
    print("Opening Box...");
    await Hive.openBox(HIVE_BOX);
    print("Box is Open...");
  }

  static Future<void> closeHiveBox() async {
    if (Hive.isBoxOpen(HIVE_BOX)) {
      await Hive.close();
    }
    return null;
  }

  static saveData({required String key, dynamic data}) {
    hiveBox.put(key, data);
  }

  static dynamic readData({required String key}) {
    var value = hiveBox.get(key);
    return value;
  }

  static deleteData({required String key}) {
    hiveBox.delete(key);
  }

  static storeCommunicationProtocol({required String protocol}) {
    saveData(key: COMMUNICATION_PROTOCOL, data: protocol);
  }

  static deleteCommunicationProtocol() {
    deleteData(key: COMMUNICATION_PROTOCOL);
  }

  static readCommunicationProtocol() {
    return readData(key: COMMUNICATION_PROTOCOL);
  }

  static storeAppInfo({required Map<String, String> appInfo}) {
    saveData(key: APP_INFO, data: appInfo);
  }

  static readAppInfo() {
    Map<dynamic, dynamic> result = readData(key: APP_INFO) ?? {};
    Map<String, String> appInfo = Map<String, String>();
    if (result != null && result.isNotEmpty) {
      for (dynamic type in result.keys) {
        appInfo[type.toString()] = result[type].toString();
      }
    }
    return appInfo;
  }

  static storeScheduleTimeSlotsInfoData(dynamic data) {
    saveData(key: SCHEDULE_TIME_SLOTS, data: data);
  }

  static readScheduleTimeSlotsInfoData() {
    return readData(key: SCHEDULE_TIME_SLOTS);
  }

  static deleteScheduleTimeSlotsInfoData() {
    deleteData(key: SCHEDULE_TIME_SLOTS);
  }

  static storeLanguageSelection({required Locale locale}) {
    String tempLocale = locale.toLanguageTag() ?? "en";
    // print("Store Locale: $tempLocale");
    saveData(key: SELECTED_LANGUAGE, data: tempLocale);

    String languageCode = locale.languageCode;
    String? scriptCode = locale.scriptCode;
    String? countryCode = locale.countryCode;

    saveData(key: SELECTED_LANGUAGE_CODE, data: languageCode);

    if (scriptCode != null && scriptCode!.isNotEmpty) {
      saveData(key: SELECTED_LANGUAGE_SCRIPT, data: scriptCode);
    }

    if (countryCode != null && countryCode.isNotEmpty) {
      saveData(key: SELECTED_LANGUAGE_COUNTRY, data: countryCode);
    }
  }

  static deleteLanguageSelection() {
    deleteData(key: SELECTED_LANGUAGE);
  }

  static String? readLanguageSelection() {
    return readData(key: SELECTED_LANGUAGE);
  }

  static Locale? readLanguageSelectionLocale() {
    String? savedLanguageCode = readData(key: SELECTED_LANGUAGE_CODE);
    if (savedLanguageCode != null && savedLanguageCode.isNotEmpty) {
      String? savedLanguageScript = readData(key: SELECTED_LANGUAGE_SCRIPT);
      String? savedLanguageCountry = readData(key: SELECTED_LANGUAGE_COUNTRY);
      if (savedLanguageScript != null && savedLanguageScript.isNotEmpty) {
        if (savedLanguageCountry != null && savedLanguageCountry.isNotEmpty) {
          return Locale.fromSubtags(
            languageCode: savedLanguageCode,
            scriptCode: savedLanguageScript,
            countryCode: savedLanguageCountry,
          );
        }
        return Locale.fromSubtags(
          languageCode: savedLanguageCode,
          scriptCode: savedLanguageScript,
        );
      }
      if (savedLanguageCountry != null && savedLanguageCountry.isNotEmpty) {
        return Locale.fromSubtags(
          languageCode: savedLanguageCode,
          countryCode: savedLanguageCountry,
        );
      }

      return Locale(savedLanguageCode);
    }
    //fallback to old
    String? savedLocale = readData(key: SELECTED_LANGUAGE);
    if (savedLocale != null && savedLocale.isNotEmpty) {
      if (savedLocale.contains("-")) {
        List<String> tokens = savedLocale.split("-");
        if (tokens.length == 3) {
          return Locale.fromSubtags(
            languageCode: tokens[0],
            scriptCode: tokens[1],
            countryCode: tokens[2],
          );
        }
        if (tokens.length == 2) {
          return Locale.fromSubtags(
            languageCode: tokens[0],
            scriptCode: tokens[1],
          );
        }
        return Locale(tokens.first);
      }
      return Locale(savedLocale);
    }
    return null;
  }

  /// Notification On/Off
  static storeNotificationEnabled(bool data) {
    saveData(key: IS_NOTIFICATION_ENABLED_KEY, data: data);
  }

  static readNotificationEnabled() {
    return readData(key: IS_NOTIFICATION_ENABLED_KEY);
  }

  static deletedNotificationEnabled() {
    return deleteData(key: IS_NOTIFICATION_ENABLED_KEY);
  }

  /// Tempreture Unit Change
  static storeChangeTempretureUnit(bool data) {
    saveData(key: CHANGE_TEMPRETURE_UNIT_KEY, data: data);
  }

  static readChangeTempretureUnit() {
    return readData(key: CHANGE_TEMPRETURE_UNIT_KEY);
  }

  static deletedChangeTempretureUnit() {
    deleteData(key: CHANGE_TEMPRETURE_UNIT_KEY);
  }

  /// Change Power Unit Key
  static storePowerUnit(bool data) {
    saveData(key: CHANGE_POWER_UNIT_KEY, data: data);
  }

  static readPowerUnit() {
    return readData(key: CHANGE_POWER_UNIT_KEY);
  }

  static deletedPowerUnit() {
    deleteData(key: CHANGE_POWER_UNIT_KEY);
  }

  /// Store Notification Formats
  static storeNotificationFormat(List<String> data) {
    saveData(key: CHANGE_NOTIFICATION_FORMAT_KEY, data: data);
  }

  static readNotificationFormat() {
    return readData(key: CHANGE_NOTIFICATION_FORMAT_KEY);
  }

  static deletedNotificationFormat() {
    deleteData(key: CHANGE_NOTIFICATION_FORMAT_KEY);
  }

  /// Delete All Store Data
  static deleteAllData() {
    deleteData(key: APP_URL);
    deleteData(key: APP_AUTHORITY);
  }

  static clearData() {
    // deleteFilterDataInfo();
    // deleteRecentSearchesInfo();
    // deleteDefaultCurrencyInfoData();
    deleteScheduleTimeSlotsInfoData();
  }
}
