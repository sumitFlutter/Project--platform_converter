import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:platform_convertor/screen/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../providers/contact_provider.dart';
import '../../providers/screen_provider.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController txtPass=TextEditingController();
  TextEditingController txtIn=TextEditingController();
  AuthProvider? authR;
  AuthProvider? authW;
  ContactProvider? providerR;
  ContactProvider? providerW;
  @override
  Widget build(BuildContext context) {
    authR=context.read<AuthProvider>();
    authW=context.watch<AuthProvider>();
    providerR=context.read<ContactProvider>();
    providerW=context.watch<ContactProvider>();
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "My Contacts",
          style: Theme.of(context).textTheme.titleLarge
        ),
        actions: [
          IconButton(onPressed: () {
                unlockDialog();
          }, icon: const Icon(Icons.lock)),
          IconButton(onPressed: () => context.read<ScreenProvider>().changePage(index: 2), icon: const Icon(Icons.settings)),
        ]
          ),
      body: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          children: [
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
                              backgroundColor: Colors.primaries[index].shade200,
                              child:Center(child: Text(providerW!.contactList[index].name!.substring(0,1),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),)),):
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
                                color: Colors.grey.shade50,
                                child: IconButton(
                                    onPressed: () async {
                                     await launchUrl(Uri.parse("tel:+91${providerW!.contactList[index].mobile}"));
                                    },
                                    icon: const Icon(Icons.call)),
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
  void lockDialog()
  {
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        title:const Text("Create a Password"),
          content: Container(
          padding: const EdgeInsets.all(15),
          child:Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(border: OutlineInputBorder(),
                hintText: "Enter your new password here:"),
                controller: txtPass,
              ),
              const SizedBox(height: 15,),
              ElevatedButton(onPressed: () {
                authR!.setPassword(pin: txtPass.text);
                authR!.getPPass();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Your Password is successfully created\n Please again tap Lock Button to see Hidden Contacts")));
                Navigator.pop(context);
                Navigator.pop(context);
                txtPass.clear();
              }, child: const Text("Create"))
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
    showDialog(context: context, builder: (context) {
      return AlertDialog(
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
                  TextField(
                    decoration: const InputDecoration(border: OutlineInputBorder(),
                        hintText: "Enter your password here:"),
                    controller: txtIn,
                  ):
                      const Text("You don't created your password Yet!"),
                  const SizedBox(height: 15,),
                  authW!.pPassword.isNotEmpty?
                  ElevatedButton(onPressed: () {
                    if(authR!.pPassword==txtIn.text)
                    {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("You entered Right Password")));
                      Navigator.pop(context);
                      Navigator.pushNamed(context, "hide");
                      txtIn.clear();
                    }
                    else
                    {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Try Again")));
                      txtIn.clear();
                      Navigator.pop(context);

                    }
                  }, child: const Text("Proceed ->")):Container(),
                  authR!.pPassword.isEmpty?TextButton(onPressed: () {
                    lockDialog();
                  }, child: const Text("Create a Password")):Container()
                ],
              ),
          ),
        ),
      );
    },);
  }
}
