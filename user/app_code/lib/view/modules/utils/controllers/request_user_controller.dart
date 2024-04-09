import 'package:app_code/view/modules/utils/models/request_user_model.dart';
import 'package:flutter/material.dart';

class RequestUserController extends ChangeNotifier {
  RequestUserModel requestUserModel = RequestUserModel(
    categoryController: TextEditingController(),
    productController: TextEditingController(),
    dateController: TextEditingController(),
    qty: 1,
  );


  void getDateValue({required String formattedDate}) {
    requestUserModel.dateController.text = formattedDate;
    notifyListeners();
  }

  void increaseQty() {
    requestUserModel.qty++;
    notifyListeners();
  }

  void decreaseQty() {
    if (requestUserModel.qty > 1) {
      requestUserModel.qty--;
    }
    notifyListeners();
  }

  void clearAllValue() {
    requestUserModel.categoryController.clear();
    requestUserModel.productController.clear();
    requestUserModel.dateController.clear();
    requestUserModel.qty = 0;
    notifyListeners();
  }
}
