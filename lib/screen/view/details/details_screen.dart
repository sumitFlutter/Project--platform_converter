import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../model/contact_model.dart';
import '../../providers/contact_provider.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  int? index;
  bool? isHidden;
  ContactProvider? providerR;
  ContactProvider? providerW;
  List<Contact>? listR;
  List<Contact>? listW;
  GlobalKey<FormState> key = GlobalKey<FormState>();
  TextEditingController txtName = TextEditingController();
  TextEditingController txtMobile = TextEditingController();
  TextEditingController txtE = TextEditingController();
  @override
  Widget build(BuildContext context) {
    providerR=context.read<ContactProvider>();
    providerW=context.watch<ContactProvider>();
    List l1=ModalRoute.of(context)!.settings.arguments as List;
    index=l1[0] as int;
    isHidden=l1[1] as bool;
   listR= isHidden==false?context.read<ContactProvider>().contactList:context.read<ContactProvider>().hiddenContactList;
    listW= isHidden==false?context.watch<ContactProvider>().contactList:context.watch<ContactProvider>().hiddenContactList;
    return SafeArea(child: Scaffold(
        appBar: AppBar(title: Text(
          "View Contact",
          style: Theme.of(context).textTheme.titleLarge
        ),
        actions: [
          IconButton.outlined(onPressed: () {
            editContact();
          }, icon: const Icon(Icons.edit)),
          IconButton.outlined(onPressed: () {isHidden==true?
            showDialog(context: context, builder: (context) => AlertDialog(title: const Text("Are you sure to remove this contact form Hidden Contacts?"),actions: [
              ElevatedButton(onPressed: () {
                providerR!.hiddenRemove(index!);
                Navigator.pop(context);
                Navigator.pop(context);
              }, child: const Text("Yes!")),
              ElevatedButton(onPressed: () {
                Navigator.pop(context);
              }, child: const Text("No!")),
            ],),): showDialog(context: context, builder: (context) => AlertDialog(title: const Text("Are you sure?"),actions: [
            ElevatedButton(onPressed: () {
              providerR!.remove(index!);
              Navigator.pop(context);
              Navigator.pop(context);
            }, child: const Text("Yes!")),
            ElevatedButton(onPressed: () {
              Navigator.pop(context);
            }, child: const Text("No!")),
          ],),);
          }, icon: const Icon(Icons.delete)),
        ],
        ),
        body:
        Container(
          width: MediaQuery.sizeOf(context).width,
          margin: const EdgeInsets.all(15),
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: listW![index!].image=="assets/image/profile.png"
                        ?
                    Center(
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.primaries[index!].shade200,
                        child: Center(child: Text(listW![index!].name!.substring(0,1),style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 30),)),
                      ),
                    ): Center(
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: FileImage(File("${listW![index!].image}")),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15,),
                  Center(
                    child: Text(
                      "${listW![index!].name}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 21),
                    ),
                  ),
                  const SizedBox(height: 15,),
                ],
              ),
              const SizedBox(height: 15,),
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      InkWell(
                        onTap: () async{
                          Uri mail= Uri.parse("mailto:${listR![index!].email}");
                          await launchUrl(mail);
                        },
                          child: const CircleAvatar(child: Icon(Icons.mail,size: 25,color: Colors.white,),backgroundColor: Colors.blue,radius: 20,)),
                      const Text("email",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)
                    ],
                  ),
                  const Column(
                    children: [
                      CircleAvatar(child: Icon(Icons.video_call,size: 25,color: Colors.white,),backgroundColor: Colors.red,radius: 20,),
                      Text("Video Call",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)
                    ],
                  ),
                  Column(
                    children: [
                      InkWell(onTap: () async {
                        Uri call= Uri.parse("tel:+91${listR![index!].mobile}");
                        await launchUrl(call);
                      },
                          child: const CircleAvatar(child: Icon(Icons.call,size: 25,color: Colors.white,),backgroundColor: Colors.green,radius: 20,)),
                      const Text("Call",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("NOW",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                  IconButton.filledTonal(onPressed: () {
                    Share.share("${listR![index!].name}\n${listR![index!].mobile}");
                  }, icon: Icon(Icons.share)),
                ],
              ),
              Row(children: [
                Column(
                  children: [
                    Text("+91 ${listW![index!].mobile}",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                    Text("${listW![index!].email}",style: const TextStyle(fontSize: 15),),
                  ],
                ),
                Spacer(),
                IconButton.filledTonal(onPressed:() async{
                  Uri call= Uri.parse("tel:+91${listR![index!].mobile}");
                  await launchUrl(call);
                },  icon: const Icon(Icons.call)),
                const SizedBox(width: 15,),
                IconButton.filledTonal(onPressed:() async{
                  Uri msg= Uri.parse("sms:+91${listR![index!].mobile}");
                  await launchUrl(msg);
                },  icon: const Icon(Icons.message)),
              ],),
              SizedBox(height: 15,),
              ListTile(title: Text("Birth Date:"),
              trailing: listW![index!].d1==DateTime.now()?Text("Birth Date is Not Choosen Yet."):Text("${listW![index!].d1!.day}/${listW![index!].d1!.month}/${listW![index!].d1!.year}")),
              Spacer(),
              BottomAppBar(
                child:  Center(
                child: IconButton.filledTonal(onPressed: () {
                  showDialog(context: context, builder: (context) {
                    return AlertDialog(
                      title: Text("Are You Sure?"),
                      actions: [
                        ElevatedButton(onPressed: () {
                          isHidden==false?
                          providerR!.createHidden(index!):
                          providerR!.hiddenRemove(index!);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        }, child: Text("Yes!")),
                        ElevatedButton(onPressed: () {
                          Navigator.pop(context);
                        }, child: Text("No!"))
                      ],
                    );
                  },);
                 },icon: isHidden==true?const Icon(Icons.lock_open_outlined):const Icon(Icons.lock_outlined),),
              ),)
            ],
          ),
        )
    ));
  }
  void editContact()
  {
    txtMobile.text=listR![index!].mobile!;
    txtE.text=listR![index!].email!;
    txtName.text=listR![index!].name!;
    providerR!.editP1(index: index!, isHidden: isHidden!);
    showAdaptiveDialog(context: context, builder: (context) {
      return  SingleChildScrollView(
        child: Material(
          child: Container(
            width: MediaQuery.sizeOf(context).width,
            margin: const EdgeInsets.all(15),
            padding: const EdgeInsets.all(15),
            color: Colors.primaries[index!].shade300,
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
                        providerW!.editI=="assets/image/profile.png"
                            ?
                        const CircleAvatar(
                          radius: 90,
                          backgroundImage: AssetImage("assets/image/profile.png"),
                        ): CircleAvatar(
                          radius: 90,
                          backgroundImage: FileImage(File(providerW!.editI!)),
                        ),
                        Align(
                            alignment: const Alignment(0.8,0.8),
                            child: IconButton(
                              onPressed: () async {
                                ImagePicker picker = ImagePicker();
                                XFile? image = await picker.pickImage(
                                    source: ImageSource.camera);
                                  providerR!.editP2(image!.path);
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
                                providerR!.editP2(image!.path);
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
                        hintText: "Enter Your name",
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
                  const SizedBox(height: 10,),
                  Text("${listW![index!].d1!.day}/${listW![index!].d1!.month}/${listW![index!].d1!.year}"),
                  SizedBox(height: 2,),
                  ElevatedButton(onPressed: () async {
                  DateTime? d2 = await showDatePicker(context: context, firstDate: DateTime(1940), lastDate: DateTime(2050),initialDate: listR![index!].d1);
                  providerR!.changeDate(d2!);
                  }, child: Text("Change Birth date:")),
                  SizedBox(height: 15,),
                  Center(
                    child: ElevatedButton(onPressed: () {
                        if (key.currentState!.validate())
                        {
                          Contact c4=Contact(name: txtName.text, mobile: txtMobile.text, image: providerR!.editI, email: txtE.text,d1: providerR!.d1);
                          providerR!.updateContact(index: index!, c3: c4,isHidden: isHidden!);
                            txtName.clear();
                            txtMobile.clear();
                            txtE.clear();
                            providerR!.d1=DateTime.now();
                            ScaffoldMessenger.of(context)!.showSnackBar(const SnackBar(content: Text("Your Contact is updated")));
                            Future.delayed(const Duration(seconds: 1),() => Navigator.pop(context));
                          }
                    },child: Text("Submit",style: Theme.of(context).textTheme.labelLarge,),),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    },);
  }
}
