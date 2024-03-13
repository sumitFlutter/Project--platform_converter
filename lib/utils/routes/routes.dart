import 'package:flutter/cupertino.dart';
import 'package:platform_convertor/screen/view/details/details_ios_screen.dart';
import 'package:platform_convertor/screen/view/hidden/hidden_ios_screen.dart';
import 'package:platform_convertor/screen/view/settings/app_setting_screen.dart';
import 'package:platform_convertor/screen/view/splesh/splesh_ios_screen.dart';

import '../../screen/view/addData/add_data_ios_screen.dart';
import '../../screen/view/addData/add_data_screen.dart';
import '../../screen/view/dash/dash_screen.dart';
import '../../screen/view/details/details_screen.dart';
import '../../screen/view/hidden/hidden_screen.dart';
import '../../screen/view/home/home_screen.dart';
import '../../screen/view/home/ios_home_screen.dart';
import '../../screen/view/intro/intro_screen.dart';
import '../../screen/view/splesh/splesh_screen.dart';

Map <String,WidgetBuilder> myRouts={
  "/":(context) => const SpleshScreen_(),
  "intro":(context) => const IntroScreen(),
  "dash":(context) => const DashScreen(),
  "home":(context) => const HomeScreen(),
  "add":(context) => const AddDataScreen(),
  "view":(context) => const DetailsScreen(),
  "hide":(context) => const HiddenScreen(),
  "settings":(context) => const SettingScreen(),
};
Map <String,WidgetBuilder> myRoutsIos={
  "/":(context) => const IosSpleshScreen(),
  "intro":(context) => const IntroScreen(),
  "home":(context) => const HomeScreenIos(),
  "add":(context) => const AddDataIosScreen(),
  "view":(context) => const DetailsIosScreen(),
  "hide":(context) => HiddenScreenIos(),
};