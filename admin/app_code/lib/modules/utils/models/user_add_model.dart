import 'dart:io';

import 'package:flutter/material.dart';

class AddUserModel {
  File? bgImage;
  File? profileImage;
  String fullName;
  String userName;
  String email;
  String password;
  bool isPasswordVisible;
  String? department;
  String bio;
  TextEditingController dobController;
  String phoneNumber;
  String gender;

  AddUserModel({
    required this.bgImage,
    required this.profileImage,
    required this.fullName,
    required this.userName,
    required this.email,
    required this.password,
    required this.isPasswordVisible,
    required this.department,
    required this.bio,
    required this.dobController,
    required this.phoneNumber,
    required this.gender,
  });
}
