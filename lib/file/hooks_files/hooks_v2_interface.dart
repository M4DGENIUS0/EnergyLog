
import 'package:app/file/hooks_files/hooks_configurations.dart';
import 'package:app/main.dart';

abstract class HooksV2Interface{
  LanguageHook getLanguageCodeAndName();
  DefaultLanguageCodeHook getDefaultLanguageHook();
  DefaultAppThemeModeHook getDefaultAppThemeModeHook();
  FontsHook getFontHook();


}