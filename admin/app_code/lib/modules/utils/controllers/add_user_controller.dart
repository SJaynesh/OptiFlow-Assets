import 'dart:io';

import 'package:app_code/modules/utils/models/user_add_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddUserController extends ChangeNotifier {
  AddUserModel addUserModel = AddUserModel(
    bgImage: null,
    profileImage: null,
    fullName: "",
    userName: "",
    email: "",
    password: "",
    isPasswordVisible: false,
    department: null,
    bio: "",
    phoneNumber: "",
    dobController: TextEditingController(),
    gender: "",
  );

  ImagePicker imagePicker = ImagePicker();

  void changeVisibilityPassword() {
    addUserModel.isPasswordVisible = !addUserModel.isPasswordVisible;
    notifyListeners();
  }

  void storeDepartment({required String department}) {
    addUserModel.department = department;
    notifyListeners();
  }

  Future<void> pickProfileImage({required ImageSource image}) async {
    XFile? xFile = await imagePicker.pickImage(source: image);
    if (xFile != null) {
      addUserModel.profileImage = File(xFile.path);
    }
    notifyListeners();
  }

  Future<void> pickBgImage({required ImageSource image}) async {
    XFile? xFile = await imagePicker.pickImage(source: image);
    if (xFile != null) {
      addUserModel.bgImage = File(xFile.path);
    }
    notifyListeners();
  }

  void getGenderValue({required String gender}) {
    addUserModel.gender = gender;
    notifyListeners();
  }

  void getDateOfBirthDay({required String date}) {
    addUserModel.dobController.text = date;
    notifyListeners();
  }

  void changeTheValueForDOBAndGender(
      {required String dob, required String gender}) {
    addUserModel.dobController.text = dob;
    addUserModel.gender = gender;
    notifyListeners();
  }

  void assignNullValue() {
    addUserModel.department = null;
    addUserModel.profileImage = null;
    addUserModel.bgImage = null;
    notifyListeners();
  }
}
