import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:platform_convertor/screen/providers/app_setting_provider.dart';
import 'package:provider/provider.dart';

import '../../providers/theme_provider.dart';
import '../../providers/ui_provider.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen>{
  GlobalKey<FormState> key = GlobalKey<FormState>();
  TextEditingController txtName = TextEditingController();
  TextEditingController txtMobile = TextEditingController();
  TextEditingController txtE = TextEditingController();
  UiProvider? uiR;
UiProvider? uiW;
SettingProvider? providerR;
SettingProvider? providerW;
  @override
  Widget build(BuildContext context) {
    uiR=context.read<UiProvider>();
    uiW=context.watch<UiProvider>();
    providerR=context.read<SettingProvider>();
    providerW=context.watch<SettingProvider>();
    providerR!.getUser();
    return SafeArea(child: Scaffold(
      appBar: AppBar(title: Text("Settings"),),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(children: [
          ListTile(title: Text("Change Theme"),trailing:  IconButton(onPressed: () => context.read<ThemeProvider>().setTheme(), icon: Icon(context.watch<ThemeProvider>().themeMode)),
            ),
          Divider(),
          ListTile(title: const Text("Ios UI"),trailing: Switch(value: uiW!.iosUi,onChanged: (value) {
            uiR!.setUi();
          },),),
          Divider(),
          ListTile(title: Text("User Account"),trailing: Icon(providerW!.isUser?Icons.arrow_drop_up_sharp:Icons.arrow_drop_down_sharp),onTap: () => providerR!.clickToggleUser(),),
          providerW!.isUser==false?Divider():Container(),
          Visibility(visible: providerW!.isUser,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: MediaQuery.sizeOf(context).width,
                    child: providerW!.pUserAc.isEmpty?Text("You don't have Created Your User Account Yet!"):
                    Column(mainAxisSize: MainAxisSize.min,
                    children: [providerW!.pUserAc[0]!="assets/image/profile.png"?
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: FileImage(File(providerR!.pUserAc[0])),
                      ):
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: AssetImage(providerR!.pUserAc[0]),
                        ),
                      SizedBox(height: 10,),
                      ListTile(title: Text(providerW!.pUserAc[1],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),)),
                      SizedBox(height: 10,),
                      ListTile(title: Text(providerW!.pUserAc[2],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),)),
                      SizedBox(height: 10,),
                      ListTile(title: Text(providerW!.pUserAc[3],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),)),
                    ],),
                  ),
                  providerW!.pUserAc.isEmpty?ElevatedButton(onPressed: () {
                    createUAc();
                  }, child: Text("Create Your User Accout")):
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(onPressed: () {

                          }, child: Text("Update Your User Account")),
                          SizedBox(height: 15,),
                          ElevatedButton(onPressed: () {

                          }, child: Text("Delete Your User Account")),
                        ]
                      ),
                ],
              )),
        ],),
      ),
    ));
  }
void createUAc()
{
  showDialog(context: context, builder: (context) {
    return  Center(
      child: Material(
        child: Container(
          width: MediaQuery.sizeOf(context).width,
          margin: const EdgeInsets.all(15),
          padding: const EdgeInsets.all(15),
          color: Colors.red.shade300,
          child: SingleChildScrollView(
            child: Form(
              key: key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    color: Colors.white,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        providerW!.uImage=="assets/image/profile.png"
                            ?
                        const CircleAvatar(
                          radius: 90,
                          backgroundImage: AssetImage("assets/image/profile.png"),
                        ): CircleAvatar(
                          radius: 90,
                          backgroundImage: FileImage(File(providerW!.uImage!)),
                        ),
                        Align(
                            alignment: const Alignment(0.8,0.8),
                            child: IconButton(
                              onPressed: () async {
                                ImagePicker picker = ImagePicker();
                                XFile? image = await picker.pickImage(
                                    source: ImageSource.camera);
                                providerR!.addPath(image!.path);
                              },
                              icon: const Icon(
                                Icons.add_a_photo_rounded,
                                color: Colors.black,
                                weight: 50,
                              ),
                            )),
                        Align(
                            alignment: const Alignment(-0.8,-0.8),
                            child: IconButton(
                              onPressed: () async {
                                ImagePicker picker = ImagePicker();
                                XFile? image = await picker.pickImage(
                                    source: ImageSource.gallery);
                                providerR!.addPath(image!.path);
                              },
                              icon: const Icon(
                                Icons.photo,
                                color: Colors.black,
                                weight: 50,
                              ),
                            ))
                      ],
                    ),
                  ),
                  const SizedBox(height: 5,),
                  const Text(
                    "Name:",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15,color: Colors.white),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.name,
                    controller: txtName,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Name is required";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        hintText: "Enter Username",
                        hintStyle: TextStyle(color: Colors.white)),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    "Mobile Number:",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15,color: Colors.white),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: txtMobile,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Mobile number is required";
                      }
                      if(value!.length!=10)
                      {
                        return "Enter valid number";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        hintText: "Enter Mobile Number",
                        hintStyle: TextStyle(color: Colors.white)),
                    style: const TextStyle(color: Colors.white),

                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    "Email Address",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15,color: Colors.white),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: txtE,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Email is required";
                      }
                      else if (!RegExp(
                          "^[a-zA-Z0-9.!#\$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*\$")
                          .hasMatch(value!)) {
                        return "enter the valid email";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        hintText: "Enter Your Email",
                        hintStyle: TextStyle(color: Colors.white)),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 15,),
                  Center(
                    child: ElevatedButton(onPressed: () {
                      if (key.currentState!.validate())
                      {
                        List <String> l1=[];
                        if(providerW!.uImage==null)
                          {
                            l1.add("assets/image/profile.png");
                          }
                        else
                          {
                            l1.add(providerR!.uImage!);
                          }
                        l1.add(txtName.text);
                        l1.add(txtMobile.text);
                        l1.add(txtE.text);
                        providerR!.setAc(l1);
                        providerR!.getUser();
                          txtName.clear();
                          txtMobile.clear();
                          txtE.clear();
                          ScaffoldMessenger.of(context)!.showSnackBar(const SnackBar(content: Text("User Account is Created")));
                          Future.delayed(const Duration(seconds: 1),() => Navigator.pop(context));
                        }
                    },child: Text("Create",style: Theme.of(context).textTheme.labelLarge,),),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  },);
}
}
