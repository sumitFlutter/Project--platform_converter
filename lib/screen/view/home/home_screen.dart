import 'dart:io';
import 'package:flutter/material.dart';
import 'package:platform_convertor/screen/providers/theme_provider.dart';
import 'package:provider/provider.dart';

import '../../providers/contact_provider.dart';
import '../../providers/screen_provider.dart';
import '../../providers/ui_provider.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ContactProvider? providerR;
  ContactProvider? providerW;
  UiProvider? uiR;
  UiProvider? uiW;
  @override
  Widget build(BuildContext context) {
    uiR=context.read<UiProvider>();
    uiW=context.watch<UiProvider>();
    providerR=context.read<ContactProvider>();
    providerW=context.watch<ContactProvider>();
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          "My Contacts",
          style: Theme.of(context).textTheme.titleLarge
        ),
        actions: [
          IconButton.filledTonal(onPressed: () {
            providerR!.auth1();
            if(providerR!.check1==true)
              {
                Navigator.pushNamed(context, "hide");
              }
            else{
              showDialog(context: context, builder: (context) {
                return AlertDialog(title: const Text("Please set Screen lock first in Device!"),actions: [
                  ElevatedButton(onPressed: () {
                    Navigator.pop(context);
                  }, child: const Text("OK!"))
                ],);
              },);
            }
          }, icon: const Icon(Icons.lock)),
          IconButton(onPressed: () => context.read<ThemeProvider>().setTheme(), icon: Icon(context.watch<ThemeProvider>().themeMode))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          children: [
            ListTile(title: const Text("Android Ui"),trailing: Switch(value: uiW!.iosUi,onChanged: (value) {
              uiR!.setUi();
            },),),
            Center(
              child: InkWell(
                onTap: () {
                  context.read<ScreenProvider>().changePage(index: 1);
                },
                child: Container(
                  height: 45,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.lightBlue.shade50,),
                  child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.person_add,color: Colors.lightBlue,),
                    const SizedBox(width: 10,),
                    Text("Create a new contact",style: Theme.of(context).textTheme.labelLarge,)
                  ],
                ),),
              ),
            ),
                Expanded(
                child: ListView.builder(
                  itemCount: providerW?.contactList.length,
                  itemBuilder: (context, index) => Container(
                    height: 80,
                    width: 80,
                    margin: const EdgeInsets.all(15),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, "view",arguments: [index,false]);
                      },
                      child: Column(
                        children: [
                          Row(
                            children: [providerW?.contactList[index].image=="assets/image/profile.png"?
                              CircleAvatar(
                                  radius: 25,
                              backgroundImage: AssetImage(providerW!.contactList[index].image!),):
                                      CircleAvatar(
                                      radius: 25,
                                          backgroundImage: FileImage(
                                              File(providerW!.contactList[index].image!))),
                              const SizedBox(width: 20,),
                              Text(
                                "${providerW?.contactList[index].name}",
                                style: const TextStyle(fontWeight: FontWeight.bold,),
                              ),
                              const Spacer(),
                              Container(
                                child: IconButton(
                                    onPressed: () {

                                        providerR!.remove(index);
                                    },
                                    icon: const Icon(Icons.delete)),
                              ),
                            ],
                          ),
                          const Divider(),
                        ],
                      ),
                    ),
                  ),
                ))
          ],
        ),
      ),
    ));
  }
}
