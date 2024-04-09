import 'dart:io';

import 'package:app_code/view/modules/utils/models/edit_page_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditPageController extends ChangeNotifier {
  EditPageModel editPageModel = EditPageModel(
    bgImage: null,
    profileImage: null,
    fullName: "",
    userName: "",
    bio: "",
    phoneNumber: "",
    dobController: TextEditingController(),
    gender: "",
  );

  ImagePicker imagePicker = ImagePicker();

  Future<void> pickProfileImage({required ImageSource image}) async {
    XFile? xFile = await imagePicker.pickImage(source: image);
    if (xFile != null) {
      editPageModel.profileImage = File(xFile.path);
    }
    notifyListeners();
  }

  Future<void> pickBgImage({required ImageSource image}) async {
    XFile? xFile = await imagePicker.pickImage(source: image);
    if (xFile != null) {
      editPageModel.bgImage = File(xFile.path);
    }
    notifyListeners();
  }

  void getGenderValue({required String gender}) {
    editPageModel.gender = gender;
    notifyListeners();
  }

  void getDateOfBirthDay({required String date}) {
    editPageModel.dobController.text = date;
    notifyListeners();
  }

  void changeTheValueForDOBAndGender(
      {required String dob, required String gender}) {
    editPageModel.dobController.text = dob;
    editPageModel.gender = gender;
    notifyListeners();
  }

  void assignNullValue() {
    editPageModel.profileImage = null;
    editPageModel.bgImage = null;
    notifyListeners();
  }
}
