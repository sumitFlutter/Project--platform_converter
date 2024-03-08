import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:platform_convertor/screen/providers/contact_provider.dart';
import 'package:platform_convertor/screen/providers/screen_provider.dart';
import 'package:platform_convertor/screen/providers/theme_provider.dart';
import 'package:platform_convertor/screen/providers/ui_provider.dart';
import 'package:platform_convertor/theme/theme.dart';
import 'package:platform_convertor/utils/routes/routes.dart';
import 'package:provider/provider.dart';

void main()
{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: ThemeProvider()),
        ChangeNotifierProvider.value(value: ContactProvider()),
        ChangeNotifierProvider.value(value: UiProvider()),
        ChangeNotifierProvider.value(value: ScreenProvider())
      ],
      child: Consumer2<ThemeProvider,UiProvider>(
        builder:  (context, value, value2, child) {
          value2.getUi();
          value2.iosUi=value2.pAppUi;
          value.getTheme();
          value.theme=value.pTheme;
          return
          value2.pAppUi==false?
          MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: light,
            darkTheme: dark,
            themeMode: value.mode,
            routes: myRouts
          ):
              CupertinoApp(
                debugShowCheckedModeBanner: false,
                routes: myRoutsIos,
              );
        },
      ),
    ),
  );
}