import 'package:app/file/app_preferences/app_preferences.dart';
import 'package:app/file/common/constants.dart';
import 'package:app/file/hive_storage_files/hive_storage_manager.dart';
import 'package:app/file/hooks_files/hooks_configurations.dart';
import 'package:app/file/theme_service_files/theme_notifier.dart';
import 'package:app/l10n/features_localization.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/main_hook/hooks_v2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:app/services/notification_service.dart';

import 'pages/parent_home.dart';
import 'providers/state_providers/locale_provider.dart';



typedef FontsHook = String Function(Locale locale);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Add edge-to-edge support for Android 15+
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: [
    SystemUiOverlay.bottom,
    SystemUiOverlay.top,
  ]);

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await HiveStorageManager.openHiveBox();
  await NotificationService().init();


  final hooksV2 = HooksV2();
  final Map<String, dynamic> hooksMap = {
    "fonts": hooksV2.getFontHook(),
    "languageNameAndCode" : hooksV2.getLanguageCodeAndName(),
    "defaultLanguageCode" : hooksV2.getDefaultLanguageHook(),
    "defaultAppThemeModeHook" : hooksV2.getDefaultAppThemeModeHook(),
  };
  HooksConfigurations.setHooks(hooksMap);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeNotifier>(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider<LocaleProvider>(create: (_) => LocaleProvider()),
      ],
      child: MyApp(fontsHook: hooksMap["fonts"]),
    ),
  );
}

class MyApp extends StatefulWidget {
  final FontsHook? fontsHook;

  const MyApp({Key? key, this.fontsHook}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, theme, child) {
        return Consumer<LocaleProvider>(
            builder: (context, localeProvider, child) {
              return MaterialApp(
                title: APP_NAME,
                locale: localeProvider.locale,
                supportedLocales: L10n.getAllLanguagesLocale(),
                localizationsDelegates: [
                  CustomLocalisationDelegate(),
                  GlobalMaterialLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                ],
                darkTheme: ThemeData(
                  popupMenuTheme: PopupMenuThemeData(
                    surfaceTintColor: Colors.transparent,
                    color: AppThemePreferences.popupMenuBgColorDark,
                  ),
                  bottomSheetTheme: BottomSheetThemeData(
                    surfaceTintColor: Colors.transparent,
                    backgroundColor: AppThemePreferences.bottomSheetBgColorDark,
                  ),
                  dialogBackgroundColor: AppThemePreferences.dialogBgColorDark,
                  textSelectionTheme: TextSelectionThemeData(
                    cursorColor: AppThemePreferences.appPrimaryColor,
                    selectionHandleColor: AppThemePreferences.appPrimaryColor,
                    selectionColor: AppThemePreferences.appPrimaryColorSwatch[300],
                  ),
                  splashColor: AppThemePreferences.selectedItemBackgroundColorDark,
                  appBarTheme: AppBarTheme(
                      systemOverlayStyle: SystemUiOverlayStyle(
                        statusBarBrightness: Brightness.dark,
                        statusBarColor: Colors.transparent,
                        // statusBarIconBrightness: Brightness.light,
                        systemNavigationBarColor: Colors.transparent,
                      )),
                  brightness: AppThemePreferences.systemBrightnessDark,
                  canvasColor: AppThemePreferences.backgroundColorDark,
                  primaryColor: AppThemePreferences.appPrimaryColor,
                  primarySwatch: AppThemePreferences.appPrimaryColorSwatch,
                  iconTheme: IconThemeData(
                      color: AppThemePreferences.appIconsMasterColorDark),
                  scaffoldBackgroundColor: AppThemePreferences.appSecondaryColor,
                  cardColor: AppThemePreferences.cardColorDark,
                  bottomNavigationBarTheme: BottomNavigationBarThemeData(
                    backgroundColor: AppThemePreferences.bottomNavBarBackgroundColorDark,
                    selectedItemColor: AppThemePreferences.bottomNavBarTintColor,
                    unselectedItemColor: AppThemePreferences.unSelectedBottomNavBarTintColor,
                  ),
                  fontFamily: widget.fontsHook != null && widget.fontsHook!(localeProvider.locale!).isNotEmpty
                      ? widget.fontsHook!(localeProvider.locale!)
                      : checkRTLDirectionality(localeProvider.locale!)
                      ? 'Cairo'
                      : 'Rubik',
                  dividerColor: AppThemePreferences.dividerColorDark,
                ),
                theme: ThemeData(
                  popupMenuTheme: PopupMenuThemeData(
                    surfaceTintColor: Colors.transparent,
                    color: AppThemePreferences.popupMenuBgColorLight,
                  ),
                  bottomSheetTheme: BottomSheetThemeData(
                    surfaceTintColor: Colors.transparent,
                    backgroundColor: AppThemePreferences.bottomSheetBgColorLight,
                  ),
                  dialogBackgroundColor: AppThemePreferences.dialogBgColorLight,
                  textSelectionTheme: TextSelectionThemeData(
                    cursorColor: AppThemePreferences.appPrimaryColor,
                    selectionHandleColor: AppThemePreferences.appPrimaryColor,
                    selectionColor: AppThemePreferences.appPrimaryColorSwatch[300],
                  ),
                  splashColor: AppThemePreferences.selectedItemBackgroundColorLight,
                  inputDecorationTheme: InputDecorationTheme(
                    fillColor: AppThemePreferences.appPrimaryColor,
                  ),
                  bottomNavigationBarTheme: BottomNavigationBarThemeData(
                    backgroundColor: AppThemePreferences.bottomNavBarBackgroundColorDark,
                    selectedItemColor: AppThemePreferences.bottomNavBarTintColor,
                    unselectedItemColor: AppThemePreferences.unSelectedBottomNavBarTintColor,
                  ),
                  appBarTheme: AppBarTheme(
                      systemOverlayStyle: SystemUiOverlayStyle(
                        statusBarBrightness: Brightness.light,
                        statusBarColor: Colors.transparent,
                        systemNavigationBarColor: Colors.transparent,
                      )),
                  brightness: AppThemePreferences.systemBrightnessLight,
                  canvasColor: AppThemePreferences.backgroundColorLight,
                  primaryColor: AppThemePreferences.appPrimaryColor,
                  primarySwatch: AppThemePreferences.appPrimaryColorSwatch,
                  iconTheme: IconThemeData(
                      color: AppThemePreferences.appIconsMasterColorLight),
                  scaffoldBackgroundColor: AppThemePreferences.backgroundColorLight,
                  fontFamily: widget.fontsHook != null && widget.fontsHook!(localeProvider.locale!).isNotEmpty
                      ? widget.fontsHook!(localeProvider.locale!)
                      : checkRTLDirectionality(localeProvider.locale!)
                      ? 'Cairo'
                      : 'Rubik',
                  dividerColor: AppThemePreferences.dividerColorDark,
                ),
                themeMode: theme.getThemeMode(),
                debugShowCheckedModeBanner: false,
                home: ParentHome()
              );
            });
      },
    );
  }

  bool checkRTLDirectionality(Locale locale) {
    return Bidi.isRtlLanguage(locale.languageCode);
  }
}