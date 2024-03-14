import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:platform_convertor/screen/providers/app_setting_provider.dart';
import 'package:platform_convertor/screen/providers/auth_provider.dart';
import 'package:platform_convertor/screen/providers/contact_provider.dart';
import 'package:provider/provider.dart';

import '../../providers/theme_provider.dart';
import '../../providers/ui_provider.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen>{
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
    return SafeArea(child: Scaffold(
      appBar: AppBar(title: Text("Settings"),),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(children: [
          ListTile(onTap: () {
            context.read<ThemeProvider>().setTheme();
          },
            title: Text("Change Theme:"),trailing:Icon(context.watch<ThemeProvider>().themeMode),
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
                      ListTile(title: Text(providerW!.pUserAc[1],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),)),
                      ListTile(title: Text(providerW!.pUserAc[2],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),)),
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
                            editUAc();
                          }, child: Text("Update Your User Account")),
                          SizedBox(height: 15,),
                          ElevatedButton(onPressed: () {
                             showDialog(context: context, builder: (context) {
                               return AlertDialog(
                                 title: Text("Are YouSure?"),
                                 actions: [
                                   ElevatedButton(onPressed: () {
                                     List<String> l1=[];
                                     providerR!.setAc(l1);
                                     providerR!.getUser();
                                     Navigator.pop(context);
                                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Your Account successfully Removed")));
                                   }, child: Text("Yes!")),
                                   ElevatedButton(onPressed: () {
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
          ListTile(title: Text("Hidden Screen's Password's Setting :"),
            onTap: () {
              providerR!.passToggle();
            },
            trailing: Icon(providerW!.isPass==true?Icons.arrow_drop_up:Icons.arrow_drop_down),),
          providerW!.isPass==false?Divider():Container(),
          providerW!.isPass==true?Column(mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            authW!.pPassword.isEmpty?ElevatedButton(onPressed: () {
              cPass();
            }, child: Text("Create a password for HiddenScreen")):
                ElevatedButton(onPressed: () {
                  uPass();
                }, child: Text("Update your Password")),
            authW!.pPassword.isNotEmpty?  ElevatedButton(onPressed: () {
              showDialog(context: context, builder: (context) {
                return AlertDialog(title: Text("Are You Sure?"),
                actions: [
                  ElevatedButton(onPressed: () {
                    authR!.setPassword(pin: "");
                    authR!.getPPass();
                    context.read<ContactProvider>().resetHidden();
                    Navigator.pop(context);
                  }, child: Text("Yes!")),
                  ElevatedButton(onPressed: () {
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
  void editUAc() {
    providerR!.editPath(providerR!.pUserAc[0]);
    txtName.text = providerR!.pUserAc[1];
    txtMobile.text = providerR!.pUserAc[2];
    txtE.text = providerR!.pUserAc[3];
    showDialog(context: context, builder: (context) {
      return SingleChildScrollView(
        child: Center(
          child: Material(
            child: Container(
              width: MediaQuery
                  .sizeOf(context)
                  .width,
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
                                alignment: const Alignment(-0.8, -0.8),
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
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.white),
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
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.white),
                      ),
                      TextFormField(
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
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.white),
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
                          if (key.currentState!.validate()) {
                            List <String> l1 = [];
                            if (providerW!.uImage == "assets/image/profile.png") {
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
                            ScaffoldMessenger.of(context)!.showSnackBar(
                                const SnackBar(
                                    content: Text("User Account is Created")));
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
        ),
      );
    },);
  }
    void cPass()
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
      showDialog(context: context, builder: (context) {
        return AlertDialog(content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Change Your Hidden_Screen's Password:"),
            SizedBox(height: 10,),
            Text("First Enter Your Old Password :"),
            TextField(controller: txtOld,
            decoration: InputDecoration(border: OutlineInputBorder(),
            hintText: "Type Your Old password"),),
            ElevatedButton(onPressed: () {
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
                TextField(
                  decoration: const InputDecoration(border: OutlineInputBorder(),
                      hintText: "Enter your new password here:"),
                  controller: txtPass,
                ),
                const SizedBox(height: 15,),
                ElevatedButton(onPressed: () {
                  authR!.setPassword(pin: txtPass.text);
                  authR!.getPPass();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Your Password is successfully CHANGED\n Please again tap Lock Button to see Hidden Contacts")));
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
