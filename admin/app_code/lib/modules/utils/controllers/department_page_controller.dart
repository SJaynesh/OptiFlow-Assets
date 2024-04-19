import 'dart:io';
import 'dart:typed_data';

import 'package:app_code/modules/utils/models/department_page_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
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
      http.MultipartRequest request = http.MultipartRequest(
        "POST",
        Uri.parse("https://api.remove.bg/v1.0/removebg"),
      );
      request.files.add(
        await http.MultipartFile.fromPath(
          "image_file",
          departmentPageModel.image!.path,
        ),
      );
      request.headers.addAll({
        "X-Api-Key": "dM7KEwgEnZwyPmTPJvBnf7GL",
      });

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        http.Response result = await http.Response.fromStream(response);
        Uint8List imageBytes = result.bodyBytes;

        Directory directory = await getTemporaryDirectory();
        File file = File(
            "${directory.path}/QA${DateTime.now().millisecondsSinceEpoch}.png");

        await file.writeAsBytes(imageBytes);

        departmentPageModel.image = file;
      }

      // Uint8List imageBytes = await departmentPageModel.image!.readAsBytes();
      // departmentPageModel.image =
      //     await removeBackground(imageBytes: imageBytes);
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
