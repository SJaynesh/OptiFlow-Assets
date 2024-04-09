import 'dart:io';

import 'package:flutter/material.dart';

class EditPageModel {
  File? bgImage;
  File? profileImage;
  String fullName;
  String userName;
  String bio;
  TextEditingController dobController;
  String phoneNumber;
  String gender;

  EditPageModel({
    required this.bgImage,
    required this.profileImage,
    required this.fullName,
    required this.userName,
    required this.bio,
    required this.phoneNumber,
    required this.dobController,
    required this.gender,
  });
}
