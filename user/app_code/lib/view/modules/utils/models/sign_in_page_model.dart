import 'package:flutter/material.dart';

class SignInPageModel {
  TextEditingController userIdController;
  TextEditingController passwordController;
  bool showPassword;
  bool circularVisibled;

  SignInPageModel({
    required this.userIdController,
    required this.passwordController,
    required this.showPassword,
    required this.circularVisibled,
  });
}
