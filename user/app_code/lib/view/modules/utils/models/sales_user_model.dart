import 'package:flutter/material.dart';

class SalesUserModel {
  String? category;
  String title;
  int price;
  int qty;
  String image;
  TextEditingController dateController;
  bool isVisibled;

  SalesUserModel({
    required this.category,
    required this.title,
    required this.price,
    required this.qty,
    required this.image,
    required this.dateController,
    required this.isVisibled,
  });
}
