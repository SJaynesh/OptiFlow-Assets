import 'package:flutter/material.dart';

class SignInPageModel {
  TextEditingController emailController;
  TextEditingController passwordController;
  bool showPassword;
  bool circularVisibled;

  SignInPageModel({
    required this.emailController,
    required this.passwordController,
    required this.showPassword,
    required this.circularVisibled,
  });
}
