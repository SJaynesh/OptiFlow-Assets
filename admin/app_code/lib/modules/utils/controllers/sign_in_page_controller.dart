import 'package:app_code/modules/utils/models/sign_in_page_model.dart';
import 'package:flutter/material.dart';

class SignInPageController extends ChangeNotifier {
  SignInPageModel signInPageModel = SignInPageModel(
    emailController: TextEditingController(),
    passwordController: TextEditingController(),
    showPassword: false,
    circularVisibled: false,
  );

  void changePasswordVisibled() {
    signInPageModel.showPassword = !signInPageModel.showPassword;
    notifyListeners();
  }

  void changeCircularVisiblity() {
    signInPageModel.circularVisibled = !signInPageModel.circularVisibled;
    notifyListeners();
  }
}
