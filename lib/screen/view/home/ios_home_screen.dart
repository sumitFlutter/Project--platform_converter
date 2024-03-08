import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../providers/contact_provider.dart';
import '../../providers/ui_provider.dart';


class HomeScreenIos extends StatefulWidget {
  const HomeScreenIos({super.key});

  @override
  State<HomeScreenIos> createState() => _HomeScreenIosState();
}

class _HomeScreenIosState extends State<HomeScreenIos> {
  UiProvider? uiR;
  UiProvider? uiW;
  ContactProvider? providerR;
  ContactProvider? providerW;

  @override
  Widget build(BuildContext context) {
    uiR = context.read<UiProvider>();
    uiW = context.watch<UiProvider>();
    providerR = context.read<ContactProvider>();
    providerW = context.watch<ContactProvider>();
    return SafeArea(
      child: CupertinoPageScaffold(
        navigationBar:CupertinoNavigationBar(
          middle: const Text("Contact App Ios"),
          trailing:  CupertinoSwitch(
            value: uiW!.iosUi,
            onChanged: (value) {
              uiR!.setUi();
            },
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Ios Ui",
                    style: TextStyle(color: CupertinoColors.black,fontSize: 20,fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20,),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "add");
                    },
                    child: Container(
                      height: 45,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: CupertinoColors.link,),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(CupertinoIcons
                              .person_add,color: CupertinoColors.systemYellow,),
                          SizedBox(width: 10,),
                          Text("Create a new contact",style: TextStyle(color:CupertinoColors.systemYellow),),
                        ],
                      ),),
                  ),
                ],
              ),
            ),
          ),
        ),
    );
  }
}
