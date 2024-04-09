import 'package:flutter/material.dart';

import '../models/sign_in_page_model.dart';

class SignInPageController extends ChangeNotifier {
  SignInPageModel signInPageModel = SignInPageModel(
    userIdController: TextEditingController(),
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
