

typedef LanguageHook = List<dynamic> Function();
typedef DefaultLanguageCodeHook = String Function();
typedef DefaultAppThemeModeHook = String? Function()?;
typedef DefaultSelectedNotificationsFormatsHook = List<String> Function();
typedef AvailableNotificationsFormatsHook = List<String> Function();

class HooksConfigurations {
  static var languageNameAndCode;
  static var defaultLanguageCode;
  static var defaultAppThemeModeHook;
  static var defaultSelectedNotificationsFormatsHook;
  static var availableNotificationsFormatsHook;





  static void setHooks(Map<String, dynamic> hooksMap) {
    if (hooksMap.isNotEmpty) {
     

      if (hooksMap.containsKey("languageNameAndCode") && hooksMap["languageNameAndCode"] != null) {
        languageNameAndCode = hooksMap["languageNameAndCode"];
      }

      if (hooksMap.containsKey("defaultLanguageCode") && hooksMap["defaultLanguageCode"] != null) {
        defaultLanguageCode = hooksMap["defaultLanguageCode"];
      }
      if (hooksMap.containsKey("defaultAppThemeModeHook") && hooksMap["defaultAppThemeModeHook"] != null) {
        defaultAppThemeModeHook = hooksMap["defaultAppThemeModeHook"];
      }
      if (hooksMap.containsKey("defaultSelectedNotificationsFormatsHook") && hooksMap["defaultSelectedNotificationsFormatsHook"] != null) {
        defaultSelectedNotificationsFormatsHook = hooksMap["defaultSelectedNotificationsFormatsHook"];
      }
      if (hooksMap.containsKey("availableNotificationsFormatsHook") && hooksMap["availableNotificationsFormatsHook"] != null) {
        availableNotificationsFormatsHook = hooksMap["availableNotificationsFormatsHook"];
      }

    }
  }
}
