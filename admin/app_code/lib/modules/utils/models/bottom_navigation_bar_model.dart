import 'package:flutter/material.dart';

class BottomNavigationBarModel {
  int index;
  List<Widget> componet;
  bool isAnimated;

  BottomNavigationBarModel({
    required this.index,
    required this.componet,
    required this.isAnimated,
  });
}
