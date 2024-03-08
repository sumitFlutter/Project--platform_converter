import 'package:flutter/cupertino.dart';

class ScreenProvider with ChangeNotifier
{
  int pageIndex=0;
  void changePage({required int index})
  {
    pageIndex=index;
    notifyListeners();
  }
}