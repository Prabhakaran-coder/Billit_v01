import 'package:flutter/material.dart';


class MyState with ChangeNotifier {
  int _currentIndex = 0;
  String _menuHeader ="";

  int get value => _currentIndex;
  String get menuHeaderValue=>_menuHeader;
  void updateValue(int indexNumber,String header) {
    _currentIndex = indexNumber;
    _menuHeader =header;
    notifyListeners(); // Notify listeners when the value is updated
  }
}