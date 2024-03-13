
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../model/contact_model.dart';
import '../../providers/contact_provider.dart';
import '../../providers/screen_provider.dart';



class AddDataScreen extends StatefulWidget {
  const AddDataScreen({super.key});

  @override
  State<AddDataScreen> createState() => _AddDataScreenState();
}

class _AddDataScreenState extends State<AddDataScreen> {
  ContactProvider? providerR;
  ContactProvider? providerW;
  GlobalKey<FormState> key = GlobalKey<FormState>();
  TextEditingController txtName = TextEditingController();
  TextEditingController txtMobile = TextEditingController();
  TextEditingController txtE = TextEditingController();
  @override
  Widget build(BuildContext context) {
    providerR=context.read<ContactProvider>();
    providerW=context.watch<ContactProvider>();
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(
                              "Create a new Contact",
                              style: Theme.of(context).textTheme.titleLarge
                            ),
            ),
            body: Container(
              width: MediaQuery.sizeOf(context).width,
              margin: const EdgeInsets.all(15),
              padding: const EdgeInsets.all(15),
              child: SingleChildScrollView(
                child: Form(
                  key: key,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stepper(
                        onStepCancel: () {
                          providerR!.cancelStep();
                },
                          onStepContinue: () {
                            providerR!.continueStep();
                          }, steps: [
                        Step(title: const Text("Pick a image:"), content:  Container(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              providerW!.path ==  "assets/image/profile.png"
                                  ? const CircleAvatar(
                                radius: 60,
                                backgroundImage: AssetImage(
                                    "assets/image/profile.png"),
                              )
                                  : CircleAvatar(
                                radius: 60,
                                backgroundImage: FileImage(File(providerW!.path!)),
                              ),
                              Align(
                                  alignment: const Alignment(0.8, 0.8),
                                  child: IconButton(
                                    onPressed: () async {
                                      ImagePicker picker = ImagePicker();
                                      XFile? image = await picker.pickImage(
                                          source: ImageSource.camera);
                                        providerR?.addPath(image!.path);
                                    },
                                    icon: const Icon(
                                      Icons.add_a_photo_rounded,
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
                                      providerR?.addPath(image!.path);
                                    },
                                    icon: const Icon(
                                      Icons.photo,
                                      weight: 50,
                                    ),
                                  ))
                            ],
                          ),
                        ),),
                        Step(title: const Text("Enter name"), content:   TextFormField(
                          keyboardType: TextInputType.name,
                          controller: txtName,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Name is required";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              hintText: "Enter Contact name",
                              enabledBorder: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.person)),
                        ),),
                        Step(title: const Text("Enter Mobile Number:"), content:     TextFormField(
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
                              enabledBorder: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.call)),
                        ),),
                        Step(title: Text("Enter Email Address"), content:  TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: txtE,
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
                          decoration: const InputDecoration(
                              hintText: "Enter Your Email",
                              enabledBorder: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.mail)),
                        ),),
                        Step(title: Text("Choose Birth Date"), content: Column(mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Birth Date => ${providerW!.d1.day}/${providerW!.d1.month}/${providerW!.d1.year}"),
                          Center(child: ElevatedButton(onPressed: () async {
                        DateTime? d2=await showDatePicker(context: context, firstDate: DateTime(1940), lastDate: DateTime(2050),initialDate: providerW!.d1);
                        providerR!.changeDate(d2!);
                          },child: Text("Choose"),),)
                        ],))
                      ],currentStep: providerW!.step),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                        if (key.currentState!.validate()) {
                            Contact c2 = Contact(
                                email: txtE.text,
                                mobile: txtMobile.text,
                                image: providerR!.path ==  "assets/image/profile.png"
                                    ? "assets/image/profile.png"
                                    : providerR!.path,
                                name: txtName.text,
                            d1: providerR!.d1);
                            providerR!.addData(c1: c2);
                            txtName.clear();
                            txtMobile.clear();
                            txtE.clear();
                            ScaffoldMessenger.of(context)!.showSnackBar(
                                SnackBar(
                                    content: Text("Your Contact is saved")));
                            context.read<ScreenProvider>().changePage(index: 0);
                            providerR!.path= "assets/image/profile.png";
                            providerR!.step=0;
                            providerR!.d1=DateTime.now();
                          }
                        else{
                          ScaffoldMessenger.of(context)!.showSnackBar(
                              const SnackBar(content: Text("All Fields are required")));
                        }
                    },
                    child: Text("Save",style: Theme.of(context).textTheme.labelLarge,),
                  ),
                ),
                    ],
                  ),
                ),
              ),
            )));
  }
}
