import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/contact_provider.dart';

class HiddenScreenIos extends StatefulWidget {
  const HiddenScreenIos({super.key});

  @override
  State<HiddenScreenIos> createState() => _HiddenScreenIosState();
}

class _HiddenScreenIosState extends State<HiddenScreenIos> {
  ContactProvider? providerR;
  ContactProvider? providerW;
  @override
  Widget build(BuildContext context) {
    providerR=context.read<ContactProvider>();
    providerW=context.watch<ContactProvider>();
    return SafeArea(child: CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text("Hidden Screen Ios"),),
      child: Padding(
      padding: const EdgeInsets.all(4),
      child: Column(
        children: [
          Expanded(
              child: ListView.builder(
                itemCount: providerW?.hiddenContactList.length,
                itemBuilder: (context, index) => Container(
                  height: 80,
                  width: 80,
                  margin: const EdgeInsets.all(15),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "view",arguments: [index,true]);
                    },
                    child: Column(
                      children: [
                        Row(
                          children: [providerW?.hiddenContactList[index].image=="assets/image/profile.png"?
                          CircleAvatar(
                            radius: 25,
                            backgroundImage: AssetImage(providerW!.hiddenContactList[index].image!),):
                          CircleAvatar(
                              radius: 25,
                              backgroundImage: FileImage(
                                  File(providerW!.hiddenContactList[index].image!))),
                            const SizedBox(width: 20,),
                            Text(
                              "${providerW?.hiddenContactList[index].name}",
                              style: const TextStyle(fontWeight: FontWeight.bold,),
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
    ),));
  }
 }
