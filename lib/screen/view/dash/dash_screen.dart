import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/screen_provider.dart';
import '../addData/add_data_screen.dart';
import '../home/home_screen.dart';

class DashScreen extends StatefulWidget {
  const DashScreen({super.key});

  @override
  State<DashScreen> createState() => _DashScreenState();
}

class _DashScreenState extends State<DashScreen> {
  ScreenProvider? providerR;
  ScreenProvider? providerW;
  List<Widget> l1 = [const HomeScreen(), const AddDataScreen()];

  @override
  Widget build(BuildContext context) {
    providerW = context.watch<ScreenProvider>();
    providerR = context.read<ScreenProvider>();
    return Scaffold(
      body: l1[providerW!.pageIndex],
      bottomNavigationBar: NavigationBar(
        destinations: [
          NavigationDestination(icon: Icon(Icons.home), label: "Home"),
          NavigationDestination(
              icon: Icon(Icons.person_add), label: "Add Contact")
        ],
        onDestinationSelected: (value) {
          providerR!.changePage(index: value);
        },
        selectedIndex: providerW!.pageIndex,
      ),
    );
  }
}
