import 'package:flutter/material.dart';

class BottomNavigationBarModel {
  int index;
  List<Widget> componets;
  bool isAnimated;

  BottomNavigationBarModel({
    required this.index,
    required this.componets,
    required this.isAnimated,
  });
}
