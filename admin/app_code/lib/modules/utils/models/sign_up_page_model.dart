import 'package:flutter/material.dart';

class SignUpPageModel {
  String countryValue;
  bool showPassword;
  bool check;
  bool termsAndCondition;
  bool load;
  bool circularVisibled;
  TextEditingController companyNameController;
  TextEditingController fullNameController;
  TextEditingController emailAddressController;
  TextEditingController passwordController;
  TextEditingController phoneNumberController;

  SignUpPageModel({
    required this.countryValue,
    required this.showPassword,
    required this.check,
    required this.termsAndCondition,
    required this.load,
    required this.circularVisibled,
    required this.companyNameController,
    required this.fullNameController,
    required this.emailAddressController,
    required this.passwordController,
    required this.phoneNumberController,
  });
}

class SignUpPageDataGetModel {
  String companyName;
  String fullName;
  String emailAddress;
  String password;
  String phoneNumber;
  String selectedCountry;

  SignUpPageDataGetModel({
    required this.companyName,
    required this.fullName,
    required this.emailAddress,
    required this.password,
    required this.phoneNumber,
    required this.selectedCountry,
  });
}
