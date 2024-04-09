import 'package:app_code/modules/utils/models/sign_up_page_model.dart';
import 'package:flutter/material.dart';

class SignUpPageController extends ChangeNotifier {
  SignUpPageModel signUpPageModel = SignUpPageModel(
    countryValue: "",
    showPassword: false,
    check: false,
    termsAndCondition: false,
    circularVisibled: false,
    companyNameController: TextEditingController(),
    fullNameController: TextEditingController(),
    load: false,
    emailAddressController: TextEditingController(),
    passwordController: TextEditingController(),
    phoneNumberController: TextEditingController(),
  );

  void changeCircularVisiblity() {
    signUpPageModel.circularVisibled = !signUpPageModel.circularVisibled;
    notifyListeners();
  }

  void changePasswordVisibled() {
    signUpPageModel.showPassword = !signUpPageModel.showPassword;
    notifyListeners();
  }

  void getCountryData({required String country}) {
    signUpPageModel.countryValue = country;
    notifyListeners();
  }

  void getCheckBoxData({required bool checked}) {
    signUpPageModel.check = checked;
    notifyListeners();
  }

  void getPasswordData({required String password}) {
    signUpPageModel.passwordController.text = password;
    notifyListeners();
  }

  void changeVisibilityTermsAndConditionLine({required bool getTerms}) {
    signUpPageModel.termsAndCondition = getTerms;
    notifyListeners();
  }

  void getLoadValue({required bool val}) {
    signUpPageModel.load = val;
    notifyListeners();
  }
}
