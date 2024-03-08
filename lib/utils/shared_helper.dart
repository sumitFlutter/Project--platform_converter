import 'package:shared_preferences/shared_preferences.dart';

void saveTheme({required bool pTheme}) async {
  SharedPreferences s1 = await SharedPreferences.getInstance();
  s1.setBool("theme", pTheme);
}

Future<bool?> applyTheme() async {
  SharedPreferences s1 = await SharedPreferences.getInstance();
  s1.getBool("theme");
  return s1.getBool("theme");
}
void setIntro({required bool pIntro}) async {
  SharedPreferences s1 = await SharedPreferences.getInstance();
  s1.setBool("intro", pIntro);
}

Future<bool?> getIntro() async {
  SharedPreferences s1 = await SharedPreferences.getInstance();
  s1.getBool("intro");
  return s1.getBool("intro");
}
void saveUi({required bool pUi}) async {
  SharedPreferences s1 = await SharedPreferences.getInstance();
  s1.setBool("ui", pUi);
}

Future<bool?> applyUi() async {
  SharedPreferences s1 = await SharedPreferences.getInstance();
  s1.getBool("ui");
  return s1.getBool("ui");
}

