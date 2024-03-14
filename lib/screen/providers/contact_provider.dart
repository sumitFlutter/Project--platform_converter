import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

import '../../utils/shared_helper.dart';
import '../model/contact_model.dart';

class ContactProvider with ChangeNotifier
{
  bool? check1=false;
  LocalAuthentication auth = LocalAuthentication();
  List<Contact> contactList=[
  ];
  List<Contact> hiddenContactList=[
  ];
  DateTime d1=DateTime.now();
  String? editI;
  String? path= "assets/image/profile.png";
  int step=0;
  void changeDate(DateTime d2)
  {
    d1=d2;
    notifyListeners();
  }
  void cancelStep()
  {
    if(step>0)
    {
      step--;
      notifyListeners();
    }
  }
  void continueStep()
  {
    if(step<4)
    {
      step++;
      notifyListeners();
    }
  }
  void addData({required Contact c1})
  {
    contactList.add(c1);
    notifyListeners();
  }
  void addPath(String p1)
  {
    path=p1;
    notifyListeners();
  }
  void remove(int index)
  {
    contactList.removeAt(index);
    notifyListeners();
  }
  void editP1({required int index,required bool isHidden})
  {
    editI=isHidden==false?contactList[index].image:hiddenContactList[index].image;
    notifyListeners();
  }
  void editP2(String image1)
  {
    editI=image1;
    notifyListeners();
  }
  void updateContact({required int index,required Contact c3,required bool isHidden})
  {
   isHidden==false?contactList[index]=c3:hiddenContactList[index]=c3;
    notifyListeners();
  }
  void createHidden(int index)
  {
    hiddenContactList.add(contactList[index]);
    contactList.removeAt(index);
    notifyListeners();

  }
  void hiddenRemove(int index)
  {
    contactList.add(hiddenContactList[index]);
    hiddenContactList.removeAt(index);
    notifyListeners();
  }
  void resetHidden()
  {
    hiddenContactList.clear();
    notifyListeners();
  }
}