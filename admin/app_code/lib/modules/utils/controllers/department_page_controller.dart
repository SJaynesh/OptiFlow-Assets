import 'dart:io';

import 'package:app_code/modules/utils/models/department_page_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DepartmentPageController extends ChangeNotifier {
  DepartmentPageModel departmentPageModel = DepartmentPageModel(
    image: null,
    title: "",
    price: 0,
    qty: 0,
    category: "",
    description: "",
    department: null,
  );

  ImagePicker imagePicker = ImagePicker();

  Future<void> pickProfileImage({required ImageSource image}) async {
    XFile? xFile = await imagePicker.pickImage(source: image);
    if (xFile != null) {
      departmentPageModel.image = File(xFile.path);
    }
    notifyListeners();
  }

  void getDepartmentPageData({required String department}) {
    departmentPageModel.department = department;
    notifyListeners();
  }

  void assignNullValue() {
    departmentPageModel.image = null;
    departmentPageModel.department = null;
    notifyListeners();
  }
}
