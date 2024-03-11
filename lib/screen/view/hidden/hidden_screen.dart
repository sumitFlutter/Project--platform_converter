import 'dart:io';

import 'package:flutter/material.dart';
import 'package:platform_convertor/screen/providers/screen_provider.dart';
import 'package:provider/provider.dart';

import '../../providers/contact_provider.dart';

class HiddenScreen extends StatefulWidget {
  const HiddenScreen({super.key});

  @override
  State<HiddenScreen> createState() => _HiddenScreenState();
}

class _HiddenScreenState extends State<HiddenScreen> {
  ContactProvider? providerR;
  ContactProvider? providerW;
  @override
  Widget build(BuildContext context) {
    providerR=context.read<ContactProvider>();
    providerW=context.watch<ContactProvider>();
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(onPressed: () {
              Navigator.pushReplacementNamed(context, "dash");
            },icon: Icon(Icons.arrow_back),),
            title: Text(
                "My  Hidden Contacts",
                style: Theme.of(context).textTheme.titleLarge
            ),
          ),
          body: Padding(
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
                        child: InkWell(
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
          ),
        ));
  }
}
