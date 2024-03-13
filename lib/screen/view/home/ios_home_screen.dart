import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/contact_provider.dart';
import '../../providers/ui_provider.dart';

class HomeScreenIos extends StatefulWidget {
  const HomeScreenIos({super.key});

  @override
  State<HomeScreenIos> createState() => _HomeScreenIosState();
}

class _HomeScreenIosState extends State<HomeScreenIos> {
  TextEditingController txtPass=TextEditingController();
  TextEditingController txtIn=TextEditingController();
  AuthProvider? authR;
  AuthProvider? authW;
  UiProvider? uiR;
  UiProvider? uiW;
  ContactProvider? providerR;
  ContactProvider? providerW;

  @override
  Widget build(BuildContext context) {
    authR=context.read<AuthProvider>();
    authW=context.watch<AuthProvider>();
    uiR = context.read<UiProvider>();
    uiW = context.watch<UiProvider>();
    providerR = context.read<ContactProvider>();
    providerW = context.watch<ContactProvider>();
    return SafeArea(
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: const Text("Contact App Ios"),
            trailing:GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, "add");
              },
                child: Icon(CupertinoIcons.person_add,color: CupertinoColors.black,)),
        ),
          child:  Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
               CupertinoListTile(
                 onTap: () {
                   unlockDialog();
                 },
                   title: Center(child: Row(
                     mainAxisSize:MainAxisSize.min,
                     children: [
                       Icon(CupertinoIcons.lock),
                       SizedBox(width: 1,),
                       Text("Hidden Contacts"),
                     ],
                   ))),
                Divider(),
                SizedBox(
                  height: 5,
                ),
                Expanded(
                    child: ListView.builder(
                      itemCount: providerW?.contactList.length,
                      itemBuilder: (context, index) =>CupertinoListTile(
                        onTap: () {
                          Navigator.pushNamed(context, "view",arguments: [index,false]);
                        },
                        leading: providerW?.contactList[index].image=="assets/image/profile.png"?
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.primaries[index].shade200,
                          child:Center(child: Text(providerW!.contactList[index].name!.substring(0,1),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),)),):
                        CircleAvatar(
                            radius: 25,
                            backgroundImage: FileImage(
                                File(providerW!.contactList[index].image!))),
                        //leadingSize: 30,
                        title:Text(
                          "${providerW?.contactList[index].name}",
                          style: const TextStyle(fontWeight: FontWeight.bold,),
                        ),
                        trailing:  Icon(CupertinoIcons.chevron_right),
                      ),/* Container(
                        height: 80,
                        width: 80,
                        margin: const EdgeInsets.all(15),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, "view",arguments: [index,false]);
                          },
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const SizedBox(width: 20,),
                                  Text(
                                    "${providerW?.contactList[index].name}",
                                    style: const TextStyle(fontWeight: FontWeight.bold,),
                                  ),
                                  const Spacer(),
                                 Icon(CupertinoIcons.chevron_right)                                ],
                              ),
                              const Divider(),
                            ],
                          ),
                        ),
                      ),*/
                    ))

              ],
            ),
          ),
        ),
    );
  }
  void lockDialog()
  {
    showCupertinoDialog(context: context, builder: (context) {
      return CupertinoAlertDialog(
        title:const Text("Create a Password"),
        content: Container(
          padding: const EdgeInsets.all(15),
          child:Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CupertinoTextField(
                decoration: BoxDecoration(border: Border.all()),
                    placeholder: "Enter your new password here:",
                controller: txtPass,
              ),
              const SizedBox(height: 15,),
              CupertinoButton(onPressed: () {
                authR!.setPassword(pin: txtPass.text);
                authR!.getPPass();
                Navigator.pop(context);
                Navigator.pop(context);
                txtPass.clear();
              }, child: const Text("Create")),
              authW!.pPassword==""?Container():const Text("Your PassWord is Created"),
            ],
          ),
        ),
      );
    });
  }
  void unlockDialog()
  {
    if(authW!.pPassword.isEmpty)
    {
      authR!.getPPass();
    }
    showCupertinoDialog(context: context, builder: (context) {
      return CupertinoAlertDialog(
        content: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.all(5),
            width: MediaQuery.sizeOf(context).width*0.75,
            child:Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Enter your password:",style: Theme.of(context).textTheme.titleLarge,),
                const SizedBox(height: 20,),
                authW!.pPassword.isNotEmpty?
                CupertinoTextField(
                  decoration: BoxDecoration(border: Border.all()),
                      placeholder: "Enter your password here:",
                  controller: txtIn,
                ):
                const Text("You don't created your password Yet!"),
                const SizedBox(height: 15,),
                authW!.pPassword.isNotEmpty?
                CupertinoButton(onPressed: () {
                  if(authR!.pPassword==txtIn.text)
                  {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, "hide");
                    txtIn.clear();
                  }
                  else
                  {
                    txtIn.clear();
                  }
                }, child: const Text("Proceed ->")):Container(),
                authR!.pPassword.isEmpty?CupertinoButton(onPressed: () {
                  lockDialog();
                }, child: const Text("Create a Password")):Container(),
                CupertinoButton(child: Text("Back To HomeScreen"), onPressed: () {
                  Navigator.pop(context);
                },)
              ],
            ),
          ),
        ),
      );
    },);
  }
}
