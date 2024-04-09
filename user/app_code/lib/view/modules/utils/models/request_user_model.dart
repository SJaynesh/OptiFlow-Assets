import 'package:flutter/material.dart';

class RequestUserModel {
  TextEditingController categoryController;
  TextEditingController productController;
  TextEditingController dateController;
  int qty;

  RequestUserModel({
    required this.categoryController,
    required this.productController,
    required this.dateController,
    required this.qty,
  });
}
