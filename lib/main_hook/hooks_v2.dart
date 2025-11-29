import 'package:app/file/hooks_files/hooks_configurations.dart';
import 'package:app/file/hooks_files/hooks_v2_interface.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';


/// Things to Add here!
/// 1. Nav Bar Design So I can Easily Change Nav Bar Design



class HooksV2 implements HooksV2Interface {

  @override
  FontsHook getFontHook() {
    FontsHook fontsHook = (Locale locale) {
      // return "Ubuntu";
      // return "Qwitcher_Grypen";
      return "";
    };

    return fontsHook;
  }


  @override
  LanguageHook getLanguageCodeAndName() {
    LanguageHook languageHook = () {
      /// Steps to add Language
      ///  Step 1:
      ///  Make sure to add LANGUAGE-CODE_localization.json is added in asset and path
      ///  must be define in project level pubspec.yaml
      ///  assets/localization/LANGUAGE-CODE_localization.json
      ///  Step 2:
      ///  Make language map by defining language Name and Language code against the keys.
      ///  Step 3:
      ///  Add your language map in the languageList.
      ///  Step 4:
      ///  Run flutter pub get command.
      ///
      ///  Optional:
      ///  You can add languageCodeForURL key in the map if you want to use
      ///  Its format is like this
      ///  "languageCodeForURL": "/tr"
      ///  or
      ///  "languageCodeForURL": "tr"


      Map<String, dynamic> arabicLanguageMap = {
        "languageName": "Arabic",
        "languageCode": "ar"
      };

      Map<String, dynamic> englishLanguageMap = {
        "languageName": "English",
        "languageCode": "en"
      };

      Map<String, dynamic> frenchLanguageMap = {
        "languageName": "French",
        "languageCode": "fr"
      };

      Map<String, dynamic> urduLanguageMap = {
        "languageName": "Urdu",
        "languageCode": "ur",
        // "languageCodeForURL": "ur"
      };

      Map<String, dynamic> russianLanguageMap = {
        "languageName": "Russian",
        "languageCode": "ru"
      };

      Map<String, dynamic> amhericLanguageMap = {
        "languageName": "Amheric",
        "languageCode": "am"
      };

      Map<String, dynamic> turkishLanguageMap = {
        "languageName": "Turkish",
        "languageCode": "tr"
      };

      Map<String, dynamic> spanishLanguageMap = {
        "languageName": "Spanish",
        "languageCode": "es"
      };

      Map<String, dynamic> romanianLanguageMap = {
        "languageName": "Romanian",
        "languageCode": "ro"
      };

      Map<String, dynamic> brazilianLanguageMap = {
        "languageName": "Brazilian",
        "languageCode": "pt"
      };

      Map<String, dynamic> persianLanguageMap = {
        "languageName": "Persian",
        "languageCode": "fa"
      };

      Map<String, dynamic> kurdishLanguageMap = {
        "languageName": "Kurdish",
        "languageCode": "ku"
      };

      List<dynamic> languageList = [
        englishLanguageMap,
        arabicLanguageMap,
        frenchLanguageMap,
        urduLanguageMap,
        russianLanguageMap,
        amhericLanguageMap,
        turkishLanguageMap,
        spanishLanguageMap,
        romanianLanguageMap,
        brazilianLanguageMap,
        persianLanguageMap,
        kurdishLanguageMap,
      ];

      return languageList;
    };

    return languageHook;
  }



  @override
  DefaultLanguageCodeHook getDefaultLanguageHook() {
    DefaultLanguageCodeHook defaultLanguageCodeHook = () {
      /// Add here your default language code
      return "en";
    };

    return defaultLanguageCodeHook;
  }


  @override
  DefaultAppThemeModeHook? getDefaultAppThemeModeHook() {
    DefaultAppThemeModeHook defaultAppThemeModeHook = () {
      return "dark";
    };

    return defaultAppThemeModeHook;
  }

}