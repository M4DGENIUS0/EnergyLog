

typedef LanguageHook = List<dynamic> Function();
typedef DefaultLanguageCodeHook = String Function();
typedef DefaultAppThemeModeHook = String? Function()?;

class HooksConfigurations {
  static var languageNameAndCode;
  static var defaultLanguageCode;
  static var defaultAppThemeModeHook;


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

    }
  }
}
