import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../model/contact_model.dart';
import '../../providers/contact_provider.dart';

class AddDataIosScreen extends StatefulWidget {
  const AddDataIosScreen({super.key});

  @override
  State<AddDataIosScreen> createState() => _AddDataIosScreenState();
}

class _AddDataIosScreenState extends State<AddDataIosScreen> {
  GlobalKey<FormState> key = GlobalKey<FormState>();
  ContactProvider? providerR;
  ContactProvider? providerW;
  TextEditingController nameTxt = TextEditingController();
  TextEditingController mobileTxt = TextEditingController();
  TextEditingController emailTxt = TextEditingController();

  @override
  Widget build(BuildContext context) {
    providerR = context.read<ContactProvider>();
    providerW = context.watch<ContactProvider>();
    return Form(
      key: key,
      child: SafeArea(
        child: CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: Text("Add Contact Screen Ios"),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          providerW!.path == "assets/image/profile.png"
                              ? const CircleAvatar(
                                  radius: 60,
                                  backgroundImage:
                                      AssetImage("assets/image/profile.png"),
                                )
                              : CircleAvatar(
                                  radius: 60,
                                  backgroundImage:
                                      FileImage(File(providerW!.path!)),
                                ),
                          Align(
                              alignment: const Alignment(0.8, 0.8),
                              child: CupertinoButton(
                                onPressed: () async {
                                  ImagePicker picker = ImagePicker();
                                  XFile? image = await picker.pickImage(
                                      source: ImageSource.camera);
                                  providerR?.addPath(image!.path);
                                },
                                child: const Icon(
                                  CupertinoIcons.photo_camera,
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
                                  providerR?.addPath(image!.path);
                                },
                                child: const Icon(
                                  CupertinoIcons.photo,
                                  weight: 50,
                                ),
                              ))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CupertinoTextFormFieldRow(
                        decoration: BoxDecoration(border: Border.all()),
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Name is required";
                          }
                          return null;
                        },
                        controller: nameTxt,
                        prefix: Icon(CupertinoIcons.person),
                        placeholder: "Enter Your Name:"),
                    SizedBox(
                      height: 10,
                    ),
                    CupertinoTextFormFieldRow(
                      decoration: BoxDecoration(border: Border.all()),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Mobile number is required";
                        }
                        if (value!.length != 10) {
                          return "Enter valid number";
                        }
                        return null;
                      },
                      controller: mobileTxt,
                      prefix: Icon(CupertinoIcons.phone),
                      placeholder: "Enter Your Mobile Number:",
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CupertinoTextFormFieldRow(
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Email is required";
                        } else if (!RegExp(
                                "^[a-zA-Z0-9.!#\$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*\$")
                            .hasMatch(value!)) {
                          return "enter the valid email";
                        }
                        return null;
                      },
                      decoration: BoxDecoration(border: Border.all()),
                      controller: emailTxt,
                      prefix: Icon(CupertinoIcons.mail),
                      placeholder: "Enter Your Email Address",
                    ),
                    SizedBox(height: 10,),
                    CupertinoListTile(subtitle:
                        Text("${providerW!.d1.day}/${providerW!.d1.month}/${providerW!.d1.year}"), title: Text("Birth Date:"),),
                    Center(
                      child: CupertinoButton(child: Text("Choose Birth Date:"), onPressed:() =>  showCupertinoModalPopup(context: context,builder: (context) {
                        return Container(
                          height: 200,
                            width: MediaQuery.sizeOf(context).width,
                            margin: EdgeInsets.all(10),
                            color: CupertinoColors.white,
                            child: CupertinoDatePicker(
                              initialDateTime: providerW!.d1,
                              mode: CupertinoDatePickerMode.date,
                              onDateTimeChanged: (value) => providerR!.changeDate(value),));

                      },)),
                    ),
                    Center(
                      child: CupertinoButton(
                          onPressed: () {
                            if (key.currentState!.validate()) {
                              Contact c1 = Contact(
                                  name: nameTxt.text,
                                  mobile: mobileTxt.text,
                                  image:
                                      providerR!.path == "assets/image/profile.png"
                                          ? "assets/image/profile.png"
                                          : providerR!.path,
                                  email: emailTxt.text,
                              d1: providerR!.d1);
                              providerR!.addData(c1: c1);
                              providerR!.d1=DateTime.now();
                              providerR!.path= "assets/image/profile.png";
                              Navigator.pop(context);
                            }
                          },
                          child: const Text("Submit")),
                    )
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
