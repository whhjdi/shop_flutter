import 'package:flutter/material.dart';

class CurrentIndexProvide with ChangeNotifier {
  int currentIndex = 0;

  void changeIndex(int newIndex) {
    currentIndex = newIndex;
    notifyListeners();
  }
}
