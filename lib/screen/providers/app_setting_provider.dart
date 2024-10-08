import 'package:flutter/cupertino.dart';
import 'package:platform_convertor/utils/shared_helper.dart';

class SettingProvider with ChangeNotifier
{
  bool oldPass=false;
  bool isPass=false;
  bool isUser=false;
  String uImage="assets/image/profile.png";
  List <String> pUserAc=[];
  void setAc(List<String> l1)
  {
    saveAc(l1: l1);
    notifyListeners();
  }
  Future<void> getUser()
  async {
    if(await getAc()==null)
      {
        pUserAc=[];
      }
    else{
      pUserAc=(await getAc())!;
    }
    notifyListeners();
  }
  void clickToggleUser()
  {
    isUser=!isUser;
    notifyListeners();
  }
  void addPath(String p1)
  {
    uImage=p1;
    notifyListeners();
  }
  void passToggle()
  {
    isPass=!isPass;
    notifyListeners();
  }
void editPath(String e1)
{
  uImage=e1;
  notifyListeners();
}
void truePass()
{
  oldPass=true;
  notifyListeners();
}
void falsePass()
{
  oldPass=false;
  notifyListeners();
}
}