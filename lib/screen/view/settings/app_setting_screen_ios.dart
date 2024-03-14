import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../providers/app_setting_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/contact_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/ui_provider.dart';

class SettingIosScreen extends StatefulWidget {
  const SettingIosScreen({super.key});

  @override
  State<SettingIosScreen> createState() => _SettingIosScreenState();
}

class _SettingIosScreenState extends State<SettingIosScreen> {
  TextEditingController txtOld=TextEditingController();
  TextEditingController txtPass=TextEditingController();
  GlobalKey<FormState> key = GlobalKey<FormState>();
  TextEditingController txtName = TextEditingController();
  TextEditingController txtMobile = TextEditingController();
  TextEditingController txtE = TextEditingController();
  UiProvider? uiR;
  UiProvider? uiW;
  SettingProvider? providerR;
  SettingProvider? providerW;
  AuthProvider? authR;
  AuthProvider? authW;
  @override
  Widget build(BuildContext context) {
    authR=context.read<AuthProvider>();
    authW=context.watch<AuthProvider>();
    uiR=context.read<UiProvider>();
    uiW=context.watch<UiProvider>();
    providerR=context.read<SettingProvider>();
    providerW=context.watch<SettingProvider>();
    providerR!.getUser();
    authR!.getPPass();
    return SafeArea(child: CupertinoPageScaffold(
      child:  Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(children: [
          CupertinoListTile(onTap: () {
            context.read<ThemeProvider>().setTheme();
          },
            title: Text("Change Theme:"),trailing:Icon(context.watch<ThemeProvider>().themeMode),
          ),
          Divider(),
          CupertinoListTile(title: const Text("Ios UI"),trailing: CupertinoSwitch(value: uiW!.iosUi,onChanged: (value) {
            uiR!.setUi();
          },),),
          Divider(),
          CupertinoListTile(title: Text("User Account"),trailing: Icon(providerW!.isUser?CupertinoIcons.arrow_up:CupertinoIcons.arrow_down),onTap: () => providerR!.clickToggleUser(),),
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
                        CupertinoListTile(title: Text(providerW!.pUserAc[1],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),)),
                        CupertinoListTile(title: Text(providerW!.pUserAc[2],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),)),
                        CupertinoListTile(title: Text(providerW!.pUserAc[3],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),)),
                      ],),
                  ),
                  providerW!.pUserAc.isEmpty?CupertinoButton(onPressed: () {
                    createUAc();
                  }, child: Text("Create Your User Accout")):
                  Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CupertinoButton(onPressed: () {
                          editUAc();
                        }, child: Text("Update Your User Account")),
                        SizedBox(height: 15,),
                        CupertinoButton(onPressed: () {
                          showCupertinoModalPopup(context: context, builder: (context) {
                            return CupertinoAlertDialog(
                              title: Text("Are YouSure?"),
                              actions: [
                                CupertinoButton(onPressed: () {
                                  List<String> l1=[];
                                  providerR!.setAc(l1);
                                  providerR!.getUser();
                                  Navigator.pop(context);
                                }, child: Text("Yes!")),
                                CupertinoButton(onPressed: () {
                                  Navigator.pop(context);
                                }, child: Text("No!"))
                              ],
                            );
                          },);
                        }, child: Text("Delete Your Account")),
                        Divider(),
                      ]
                  ),
                ],
              )),
          CupertinoListTile(title: Text("Hidden Screen's Password's Setting :"),
            onTap: () {
              providerR!.passToggle();
            },
            trailing: Icon(providerW!.isPass==true?CupertinoIcons.arrow_up:CupertinoIcons.arrow_down),),
          providerW!.isPass==false?Divider():Container(),
          providerW!.isPass==true?Column(mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              authW!.pPassword.isEmpty?CupertinoButton(onPressed: () {
                cPass();
              }, child: Text("Create a password for HiddenScreen")):
              CupertinoButton(onPressed: () {
                uPass();
              }, child: Text("Update your Password")),
              authW!.pPassword.isNotEmpty?  CupertinoButton(onPressed: () {
                showCupertinoModalPopup(context: context, builder: (context) {
                  return CupertinoAlertDialog(title: Text("Are You Sure?"),
                    actions: [
                      CupertinoButton(onPressed: () {
                        authR!.setPassword(pin: "");
                        authR!.getPPass();
                        context.read<ContactProvider>().resetHidden();
                        Navigator.pop(context);
                      }, child: Text("Yes!")),
                      CupertinoButton(onPressed: () {
                        Navigator.pop(context);
                      }, child: Text("No!"))
                    ],);
                },);
              }, child: Text("Reset your Password")):Container(),
              Divider(),
            ],):Container()
        ],),
      ),
    ));
  }

  void createUAc()
  {
    txtName.clear();
    txtMobile.clear();
    txtE.clear();
    providerR!.editPath("assets/image/profile.png");
    showCupertinoDialog(context: context, builder: (context) {
      return  Center(
        child: Container(
          width: MediaQuery.sizeOf(context).width,
          margin: const EdgeInsets.all(15),
          padding: const EdgeInsets.all(15),
          color: CupertinoColors.white,
          child: Form(
            key: key,
            child: SingleChildScrollView(
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
                            child: CupertinoButton(
                              onPressed: () async {
                                ImagePicker picker = ImagePicker();
                                XFile? image = await picker.pickImage(
                                    source: ImageSource.camera);
                                providerR!.addPath(image!.path);
                              },
                              child: const Icon(
                                CupertinoIcons.photo_camera,
                                color: Colors.black,
                                weight: 50,
                              ),
                            )),
                        Align(
                            alignment: const Alignment(-0.8,-0.8),
                            child: CupertinoButton(
                              onPressed: () async {
                                ImagePicker picker = ImagePicker();
                                XFile? image = await picker.pickImage(
                                    source: ImageSource.gallery);
                                providerR!.addPath(image!.path);
                              },
                              child: const Icon(
                                CupertinoIcons.photo_on_rectangle,
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
                  CupertinoTextFormFieldRow(
                    keyboardType: TextInputType.name,
                    controller: txtName,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Name is required";
                      }
                      return null;
                    },
                    decoration:BoxDecoration(border: Border.all()),
                        placeholder: "Enter Username",
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    "Mobile Number:",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15,color: Colors.white),
                  ),
                  CupertinoTextFormFieldRow(
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
                    decoration: BoxDecoration(border: Border.all()),
                        placeholder: "Enter Mobile Number",

                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    "Email Address",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15,color: Colors.white),
                  ),
                  CupertinoTextFormFieldRow(
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
                    decoration: BoxDecoration(border: Border.all()),
                        placeholder: "Enter Your Email",
                  ),
                  const SizedBox(height: 15,),
                  Center(
                    child: CupertinoButton(onPressed: () {
                      if (key.currentState!.validate())
                      {
                        List <String> l1=[];
                        if(providerW!.uImage=="assets/image/profile.png")
                        {
                          l1.add("assets/image/profile.png");
                        }
                        else
                        {
                          l1.add(providerR!.uImage);
                        }
                        l1.add(txtName.text);
                        l1.add(txtMobile.text);
                        l1.add(txtE.text);
                        providerR!.setAc(l1);
                        providerR!.getUser();
                        txtName.clear();
                        txtMobile.clear();
                        txtE.clear();
                        Future.delayed(const Duration(seconds: 1),() => Navigator.pop(context));
                      }
                    },child: Text("Create",style: Theme.of(context).textTheme.labelLarge,),),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    },);
  }
  void editUAc() {
    providerR!.editPath(providerR!.pUserAc[0]);
    txtName.text = providerR!.pUserAc[1];
    txtMobile.text = providerR!.pUserAc[2];
    txtE.text = providerR!.pUserAc[3];
    showCupertinoDialog(context: context, builder: (context) {
      return Center(
        child: Material(
          child: Container(
            width: MediaQuery
                .sizeOf(context)
                .width,
            margin: const EdgeInsets.all(15),
            padding: const EdgeInsets.all(15),
            child: Form(
              key: key,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      color: Colors.white,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          providerW!.uImage == "assets/image/profile.png"
                              ?
                          const CircleAvatar(
                            radius: 90,
                            backgroundImage: AssetImage(
                                "assets/image/profile.png"),
                          ) : CircleAvatar(
                            radius: 90,
                            backgroundImage: FileImage(
                                File(providerW!.uImage!)),
                          ),
                          Align(
                              alignment: const Alignment(0.8, 0.8),
                              child: CupertinoButton(
                                onPressed: () async {
                                  ImagePicker picker = ImagePicker();
                                  XFile? image = await picker.pickImage(
                                      source: ImageSource.camera);
                                  providerR!.addPath(image!.path);
                                },
                                child: const Icon(
                                  Icons.add_a_photo_rounded,
                                  color: Colors.black,
                                  weight: 50,
                                ),
                              )),
                          Align(
                              alignment: const Alignment(-0.8, -0.8),
                              child: CupertinoButton(
                                onPressed: () async {
                                  ImagePicker picker = ImagePicker();
                                  XFile? image = await picker.pickImage(
                                      source: ImageSource.gallery);
                                  providerR!.addPath(image!.path);
                                },
                                child: const Icon(
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
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.white),
                    ),
                    CupertinoTextFormFieldRow(
                      keyboardType: TextInputType.name,
                      controller: txtName,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Name is required";
                        }
                        return null;
                      },
                      decoration: BoxDecoration(border: Border.all()),
                          placeholder: "Enter Username",
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      "Mobile Number:",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.white),
                    ),
                    CupertinoTextFormFieldRow(
                      keyboardType: TextInputType.number,
                      controller: txtMobile,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Mobile number is required";
                        }
                        if (value!.length != 10) {
                          return "Enter valid number";
                        }
                        return null;
                      },
                      decoration:BoxDecoration(border: Border.all()),
                          placeholder: "Enter Mobile Number",
                      style: const TextStyle(color: Colors.white),

                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      "Email Address",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.white),
                    ),
                    CupertinoTextFormFieldRow(
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
                      decoration: BoxDecoration(border: Border.all()),
                          placeholder: "Enter Your Email",
                    ),
                    const SizedBox(height: 15,),
                    Center(
                      child: CupertinoButton(onPressed: () {
                        if (key.currentState!.validate()) {
                          List <String> l1 = [];
                          if (providerW!.uImage=="assets/image/profile.png" ) {
                            l1.add("assets/image/profile.png");
                          }
                          else {
                            l1.add(providerR!.uImage);
                          }
                          l1.add(txtName.text);
                          l1.add(txtMobile.text);
                          l1.add(txtE.text);
                          providerR!.setAc(l1);
                          providerR!.getUser();
                          txtName.clear();
                          txtMobile.clear();
                          txtE.clear();
                          Future.delayed(const Duration(seconds: 1), () =>
                              Navigator.pop(context));
                        }
                      }, child: Text("Edit", style: Theme
                          .of(context)
                          .textTheme
                          .labelLarge,),),
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
  void cPass()
  {
    showCupertinoModalPopup(context: context, builder: (context) {
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
                txtPass.clear();
              }, child: const Text("Create"))
            ],
          ),
        ),
      );
    });
  }
  void uPass()
  {
    showCupertinoModalPopup(context: context, builder: (context) {
      return CupertinoAlertDialog(content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Change Your Hidden_Screen's Password:"),
          SizedBox(height: 10,),
          Text("First Enter Your Old Password :"),
          CupertinoTextField(controller: txtOld,
                decoration: BoxDecoration(border: Border.all()),
                placeholder: "Type Your Old password"),
          CupertinoButton(onPressed: () {
            if(txtOld.text==authR!.pPassword)
            {
              providerR!.truePass();
            }
            else{
              Navigator.pop(context);
            }
          }, child: Text("Submit")),
          SizedBox(height: 10,),
          const Text("IF YOU ENTERED RIGHT OLD PASSWORD YOU WILL NEW TEXT FIELD \nOIN THAT TEXT FIELD YOU HAVE TO ENTER YOUR NEW PASSWORD\nTHEN SUBMIT IT\nELSE YOU WILL BE TELEPORTED TO SETTING SCREEN"),
          providerW!.oldPass==false?Container():Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CupertinoTextField(
                    placeholder: "Enter your new password here:",
                controller: txtPass,
              ),
              const SizedBox(height: 15,),
              CupertinoButton(onPressed: () {
                authR!.setPassword(pin: txtPass.text);
                authR!.getPPass();
                Navigator.pop(context);
                txtPass.clear();
                providerR!.falsePass();
              }, child: const Text("change"))

            ],
          )
        ],
      ),);
    },);
  }

}
