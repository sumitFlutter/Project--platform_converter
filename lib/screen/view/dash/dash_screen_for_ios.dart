import 'package:flutter/cupertino.dart';
import 'package:platform_convertor/screen/providers/screen_provider.dart';
import 'package:provider/provider.dart';

class DashIosScreen extends StatefulWidget {
  const DashIosScreen({super.key});

  @override
  State<DashIosScreen> createState() => _DashIosScreenState();
}

class _DashIosScreenState extends State<DashIosScreen> {
  ScreenProvider? screenR;
  ScreenProvider? screenW;
  @override
  Widget build(BuildContext context) {
    screenR=context.read<ScreenProvider>();
    screenW=context.watch<ScreenProvider>();
    return SafeArea(
      child: CupertinoTabScaffold(tabBar: CupertinoTabBar(currentIndex: screenW!.iosPageIndex,
        backgroundColor: CupertinoColors.white,
        onTap: (value) {
          screenW!.changePageIos(index: value);
        },
        items: const [BottomNavigationBarItem(icon: Icon(CupertinoIcons.home),label: "Home"),
        BottomNavigationBarItem(icon: Icon(CupertinoIcons.person_add),label: "add Contact"),
        BottomNavigationBarItem(icon: Icon(CupertinoIcons.settings),label: "Settings")],), tabBuilder:(context, index) {
          return screenR!.iosScreens[screenW!.iosPageIndex];
        },),
    );
  }
}
