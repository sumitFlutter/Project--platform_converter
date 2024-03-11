import 'package:platform_convertor/screen/providers/app_setting_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../screen/providers/auth_provider.dart';
import '../../screen/providers/contact_provider.dart';
import '../../screen/providers/screen_provider.dart';
import '../../screen/providers/theme_provider.dart';
import '../../screen/providers/ui_provider.dart';

List <SingleChildWidget> providerDeclaration=[
  ChangeNotifierProvider.value(value: ThemeProvider()),
  ChangeNotifierProvider.value(value: ContactProvider()),
  ChangeNotifierProvider.value(value: UiProvider()),
  ChangeNotifierProvider.value(value: ScreenProvider()),
  ChangeNotifierProvider.value(value: AuthProvider()),
  ChangeNotifierProvider.value(value: SettingProvider())
];