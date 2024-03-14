import 'package:flutter/cupertino.dart';
import 'package:platform_convertor/screen/view/addData/add_data_ios_screen.dart';
import 'package:platform_convertor/screen/view/home/ios_home_screen.dart';
import 'package:platform_convertor/screen/view/settings/app_setting_screen.dart';
import 'package:platform_convertor/screen/view/settings/app_setting_screen_ios.dart';

import '../view/addData/add_data_screen.dart';
import '../view/home/home_screen.dart';

class ScreenProvider with ChangeNotifier
{
  List<Widget> iosScreens=[const HomeScreenIos(),const AddDataIosScreen(),const SettingIosScreen()];
  int iosPageIndex=0;
  List<Widget> androidScreens = [const HomeScreen(), const AddDataScreen(),const SettingScreen()];
  int pageIndex=0;
  void changePage({required int index})
  {
    pageIndex=index;
    notifyListeners();
  }
  void changePageIos({required int index})
  {
    iosPageIndex=index;
    notifyListeners();
  }
}