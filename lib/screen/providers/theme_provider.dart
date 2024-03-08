import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/shared_helper.dart';

class ThemeProvider with ChangeNotifier{
  bool introScreen=false;
  String introImage="assets/image/1.png";
  bool theme=false;
  ThemeMode mode=ThemeMode.light;
  IconData themeMode=Icons.dark_mode;
  bool pTheme=false;
  void setTheme()
  async {
    theme=!theme;
    saveTheme(pTheme: theme);
    pTheme=(await applyTheme())!;
    if(pTheme==true)
    {
      mode=ThemeMode.dark;
      themeMode=Icons.light_mode;
    }
    else if(pTheme==false)
    {
      mode=ThemeMode.light;
      themeMode=Icons.dark_mode;
    }
    else
    {
      mode=ThemeMode.light;
      themeMode=Icons.dark_mode;
    }
    notifyListeners();
  }
  void getTheme()
  async{
    if(await applyTheme()==null)
    {
      pTheme=false;
    }
    else
    {
      pTheme=(await applyTheme())!;
    }
    if(pTheme==true)
    {
      mode=ThemeMode.dark;
      themeMode=Icons.light_mode;
      introImage="assets/image/2.png";
    }
    else if(pTheme==false)
    {
      mode=ThemeMode.light;
      themeMode=Icons.dark_mode;
      introImage="assets/image/1.png";
    }
    else
    {
      mode=ThemeMode.light;
      themeMode=Icons.dark_mode;
      introImage="assets/image/1.png";
    }
    notifyListeners();
  }
  void getIntroStatus()
  async {
    introScreen=(await getIntro())??false;

    print("=============$introScreen");
  }
  void introToggle()
  {
    introScreen=true;
    setIntro(pIntro: introScreen);
  }


}