import 'package:flutter/cupertino.dart';
import 'package:platform_convertor/screen/view/settings/app_setting_screen.dart';

import '../view/addData/add_data_screen.dart';
import '../view/home/home_screen.dart';

class ScreenProvider with ChangeNotifier
{
  List<Widget> androidScreens = [const HomeScreen(), const AddDataScreen(),const SettingScreen()];
  int pageIndex=0;
  void changePage({required int index})
  {
    pageIndex=index;
    notifyListeners();
  }
}