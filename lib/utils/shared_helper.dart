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
void saveKey({required String password}) async {
  SharedPreferences s1 = await SharedPreferences.getInstance();
  s1.setString("pass", password);
}

Future<String?> getKey() async {
  SharedPreferences s1 = await SharedPreferences.getInstance();
  s1.getString("pass");
  return s1.getString("pass");
}
void saveAc({required List <String> l1}) async {
  SharedPreferences s1 = await SharedPreferences.getInstance();
  s1.setStringList("ac", l1);
}

Future<List<String>?> getAc() async {
  SharedPreferences s1 = await SharedPreferences.getInstance();
  s1.getStringList("ac");
  return s1.getStringList("ac");
}

