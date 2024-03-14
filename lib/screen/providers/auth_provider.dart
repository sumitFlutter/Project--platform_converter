import 'package:flutter/cupertino.dart';
import 'package:platform_convertor/utils/shared_helper.dart';

class AuthProvider with ChangeNotifier{
  String pPassword="";
  String password="";
  void setPassword({required String pin}) {
    password=pin;
    saveKey(password: password);
    notifyListeners();
}
void getPPass()
async {
    if(await getKey()==null)
        {
          pPassword="";
        }
    else{
           pPassword=(await getKey())!;
        }
   notifyListeners();
}
}