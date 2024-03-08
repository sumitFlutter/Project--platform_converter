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
  String? editI;
  String? path= "assets/image/profile.png";
  int step=0;

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
    if(step<3)
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
  void editP1(int index)
  {
    editI=contactList[index].image;
    notifyListeners();
  }
  void editP2(String image1)
  {
    editI=image1;
    notifyListeners();
  }
  void updateContact({required int index,required Contact c3})
  {
    contactList[index]=c3;
    notifyListeners();
  }
  Future<bool?> lock()
  async{
    bool mainV=false;
    bool check = await auth.canCheckBiometrics;
    check=true;
    print(check);
    if(check)
      {
        List<BiometricType> l1 = await auth.getAvailableBiometrics();
        if(l1.isNotEmpty)
          {
            if(l1.contains(BiometricType.weak)||l1.contains(BiometricType.strong)||l1.contains(BiometricType.fingerprint)||l1.contains(BiometricType.face)||l1.contains(BiometricType.iris))
              {
                mainV = await auth.authenticate(
                    localizedReason: 'Please authenticate to proceed',
                    options: AuthenticationOptions(useErrorDialogs: true,));
              }
              return mainV;
          }
      }

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
  void auth1()
  async {
    lock();
    check1=await lock();

  }
}