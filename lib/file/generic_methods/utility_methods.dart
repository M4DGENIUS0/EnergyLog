import 'dart:io';
import 'dart:math';

import 'package:app/file/common/constants.dart';
import 'package:app/file/hive_storage_files/hive_storage_manager.dart';
import 'package:app/l10n/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;


class UtilityMethods{


  static bool validateURL(String? url){
    if(url == null || url.isEmpty){
      return false;
    }
    bool isURLValid = Uri.parse(url).isAbsolute;
    return isURLValid;
  }

  static String getLocalizedString(String key,{List? inputWords}){
    if (inputWords == null) {
      String translated = key.localisedString([]) ?? key;
      if (translated == "null") {
        return key;
      }
      return key.localisedString([]) ?? key;
    } else {
      String translated = key.localisedString(inputWords) ?? key;
      if (translated == "null") {
        return key;
      }
      return key.localisedString(inputWords) ?? key;
    }
  }

  static bool isRTL(BuildContext context) {
    return Bidi.isRtlLanguage(Localizations.localeOf(context).languageCode);
  }

  static String toTitleCase(String inputString){
    return inputString.replaceAll(RegExp(' +'), ' ').split(" ").map((str) => toCapitalized(str)).join(" ");
  }

  static String toCapitalized(String inputString) {
    return inputString.isNotEmpty ?'${inputString[0].toUpperCase()}${inputString.substring(1)}':'';
  }

  static String stripHtmlIfNeeded(String text) {
    return text.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ');
  }

  static NumberFormat getNumberFormat(){
    NumberFormat? numberFormat;
    if(THOUSAND_SEPARATOR == ",") {
      numberFormat =  NumberFormat("#$THOUSAND_SEPARATOR###$DECIMAL_POINT_SEPARATOR##");
    } else if(THOUSAND_SEPARATOR == ".") {
      numberFormat = NumberFormat.currency(locale: 'eu',customPattern: '#$DECIMAL_POINT_SEPARATOR###', decimalDigits: 0);

    } else if(THOUSAND_SEPARATOR == " ") {
      numberFormat = NumberFormat.currency(locale: 'fr',customPattern: '#,###', decimalDigits: 0);
    }
    return numberFormat!;
  }


  static void navigateToRoute({
    required context,
    required WidgetBuilder builder
  }){
    Route pageRoute = MaterialPageRoute(builder: builder);
    Navigator.push(context, pageRoute);

  }

  static void navigateToRouteByReplacement({
    required context,
    required WidgetBuilder builder
  }){
    Route pageRoute = MaterialPageRoute(builder: builder);
    Navigator.pushReplacement(context, pageRoute);
  }

  static void navigateToRouteByPushAndRemoveUntil({
    required context,
    required WidgetBuilder builder
  }){
    Route pageRoute = MaterialPageRoute(builder: builder);
    Navigator.pushAndRemoveUntil(context, pageRoute, (route) => false);
    // Navigator.of(context).pushAndRemoveUntil(pageRoute, (Route<dynamic> route) => false);
  }


  static MaterialColor getMaterialColor(String hexValue){
    int? colorValue;

    if(hexValue.contains("#")){
      colorValue = int.parse(hexValue.substring(1), radix: 16);
    }

    Map<int, Color> colorCodes = {
      50: Color(colorValue!).withAlpha((255.0 * 0.1).round()),
      100: Color(colorValue).withAlpha((255.0 * 0.2).round()),
      200: Color(colorValue).withAlpha((255.0 * 0.3).round()),
      300: Color(colorValue).withAlpha((255.0 * 0.4).round()),
      400: Color(colorValue).withAlpha((255.0 * 0.5).round()),
      500: Color(colorValue).withAlpha((255.0 * 0.6).round()),
      600: Color(colorValue).withAlpha((255.0 * 0.7).round()),
      700: Color(colorValue).withAlpha((255.0 * 0.8).round()),
      800: Color(colorValue).withAlpha((255.0 * 0.9).round()),
      900: Color(colorValue).withAlpha((255.0 * 1.0).round()),
    };

    MaterialColor materialColor = MaterialColor(colorValue, colorCodes);
    return materialColor;
  }

  static Color getColorFromString(String hexValue){
    int? colorValue;
    if(hexValue.contains("#")){
      colorValue = int.parse(hexValue.substring(1), radix: 16);
    }
    return Color(colorValue!);
  }

  /// check if the string contains only numbers
  static bool isNumeric(String str) {
    RegExp _numeric = RegExp(r'^-?[0-9]+$');
    return _numeric.hasMatch(str);
  }

  /// check if the string contains only characters
  static bool isText(String str) {
    RegExp text = RegExp(r'^-?[A-Za-z]+$');
    return text.hasMatch(str);
  }



  /// Returns true if 'inputItem' is not null and non-empty String.
  static bool isValidString(dynamic inputItem){
    if(inputItem is String && inputItem.isNotEmpty){
      return true;
    }
    return false;
  }

  static getRandomNumber({int? maxRange}){
    return Random().nextInt(maxRange ?? 1000);
  }

  static String getTimeAgoFormat({required String? time, String? locale = 'en'}) {
    if (time != null && time.isNotEmpty) {
      DateTime dt = DateTime.parse(time + "z");
      String lang = HiveStorageManager.readLanguageSelection() ?? "en";
      initializeLocaleForTimeAgo();
      return timeago.format(dt, locale: lang);
    }
    return "";
  }

  static initializeLocaleForTimeAgo() {
    timeago.setLocaleMessages('ar', timeago.ArMessages());
    timeago.setLocaleMessages('az', timeago.AzMessages());
    timeago.setLocaleMessages('ca', timeago.CaMessages());
    timeago.setLocaleMessages('cs', timeago.CsMessages());
    timeago.setLocaleMessages('da', timeago.DaMessages());
    timeago.setLocaleMessages('de', timeago.DeMessages());
    timeago.setLocaleMessages('dv', timeago.DvMessages());
    timeago.setLocaleMessages('en', timeago.EnMessages());
    timeago.setLocaleMessages('es', timeago.EsMessages());
    timeago.setLocaleMessages('et', timeago.EtMessages());
    timeago.setLocaleMessages('fa', timeago.FaMessages());
    timeago.setLocaleMessages('fi', timeago.FiMessages());
    timeago.setLocaleMessages('fr', timeago.FrMessages());
    timeago.setLocaleMessages('gr', timeago.GrMessages());
    timeago.setLocaleMessages('he', timeago.HeMessages());
    timeago.setLocaleMessages('he', timeago.HeMessages());
    timeago.setLocaleMessages('hi', timeago.HiMessages());
    timeago.setLocaleMessages('hu', timeago.HuMessages());
    timeago.setLocaleMessages('id', timeago.IdMessages());
    timeago.setLocaleMessages('it', timeago.ItMessages());
    timeago.setLocaleMessages('ja', timeago.JaMessages());
    timeago.setLocaleMessages('km', timeago.KmMessages());
    timeago.setLocaleMessages('ko', timeago.KoMessages());
    timeago.setLocaleMessages('ku', timeago.KuMessages());
    timeago.setLocaleMessages('mn', timeago.MnMessages());
    timeago.setLocaleMessages('nl', timeago.NlMessages());
    timeago.setLocaleMessages('pl', timeago.PlMessages());
    timeago.setLocaleMessages('ro', timeago.RoMessages());
    timeago.setLocaleMessages('ru', timeago.RuMessages());
    timeago.setLocaleMessages('rw', timeago.RwMessages());
    timeago.setLocaleMessages('sv', timeago.SvMessages());
    timeago.setLocaleMessages('ta', timeago.TaMessages());
    timeago.setLocaleMessages('th', timeago.ThMessages());
    timeago.setLocaleMessages('tr', timeago.TrMessages());
    timeago.setLocaleMessages('uk', timeago.UkMessages());
    timeago.setLocaleMessages('ur', timeago.UrMessages());
    timeago.setLocaleMessages('vi', timeago.ViMessages());
    timeago.setLocaleMessages('zh', timeago.ZhMessages());
  }



  static String getStringFromList(List<String>? dataList,
      { String splitPattern = "," }) {
    String dataString = "";

    if (dataList != null && dataList.isNotEmpty) {
      // convert List<String> to String
      dataString = dataList.join(splitPattern);
    }

    return dataString;
  }





  static String getFormattedDate(String? gmtDate) {
    String sanitizedDate = "";
    if (gmtDate != null && gmtDate.isNotEmpty) {
      DateTime dateTime = DateTime.parse(gmtDate);
      sanitizedDate = DateFormat.yMMMMd(HiveStorageManager.readLanguageSelection() ?? 'en').format(dateTime);
    }
    return sanitizedDate;
  }


  static String formatPercentage(int percentage) {
    if (percentage > 0) {
      return "+${percentage}%";
    } else if (percentage < 0) {
      return "-${percentage}%";
    } else {
      return "0%";
    }
  }



  static void printAttentionMessage(String reason) {
    print("***************************************************************");

  }



  static String get _getDeviceType {

    // final double physicalWidth = WidgetsBinding.instance.platformDispatcher.views.first.physicalSize.width;
    // final double devicePixelRatio =
    //     WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
    // final double width = physicalWidth / devicePixelRatio;
    final data = MediaQueryData.fromView(WidgetsBinding.instance.platformDispatcher.views.single);
    //print("window shortest size ${data.size.shortestSide}");
    return data.size.shortestSide < 700 ? 'phone' : 'tablet';
  }

  static bool get isTablet {
    return _getDeviceType == 'tablet';
  }

  static bool get showTabletView {
    return (Platform.isIOS && isTablet);
  }



  static TextInputType getKeyboardType(String? type) {
    if(type == textKeyboardType) {
      return TextInputType.text;
    } else if(type == numberKeyboardType) {
      return TextInputType.number;
    } else if(type == urlKeyboardType) {
      return TextInputType.url;
    } else if(type == emailKeyboardType) {
      return TextInputType.emailAddress;
    } else if(type == multilineKeyboardType) {
      return TextInputType.multiline;
    }
    return TextInputType.text;
  }

  static String getStringKeyboardType(TextInputType? type) {
    if(type == TextInputType.text) {
      return textKeyboardType;
    } else if(type == TextInputType.number) {
      return numberKeyboardType;
    } else if(type == TextInputType.url) {
      return urlKeyboardType;
    } else if(type == TextInputType.emailAddress) {
      return emailKeyboardType;
    } else if(type == TextInputType.multiline) {
      return multilineKeyboardType;
    }
    return textKeyboardType;
  }

  static Map<String, dynamic> bottomNavBarMap() {
    return {
      "Battery": Icons.battery_charging_full,
      "Monitor": Icons.monitor,
      "Device Info": Icons.info,
      "App Info": Icons.apps,
    };
  }
}