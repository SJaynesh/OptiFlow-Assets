import 'package:app_code/view/modules/utils/models/sales_user_model.dart';
import 'package:flutter/material.dart';

class SalesUserController extends ChangeNotifier {
  SalesUserModel salesUser = SalesUserModel(
    category: null,
    title: "",
    price: 0,
    qty: 1,
    image: "",
    dateController: TextEditingController(),
    isVisibled: false,
  );

  void getCategoryForDropDown({required var value}) {
    salesUser.category = value;
    notifyListeners();
  }

  void getDateValue({required String formattedDate}) {
    salesUser.dateController.text = formattedDate;
    notifyListeners();
  }

  void changeVisibility() {
    salesUser.isVisibled = !salesUser.isVisibled;
    notifyListeners();
  }

  void increaseQty() {
    salesUser.qty++;
    notifyListeners();
  }

  void decreaseQty() {
    if (salesUser.qty > 1) {
      salesUser.qty--;
    }
    notifyListeners();
  }

  void getProductData({
    required String category,
    required String title,
    required int price,
    required String image,
  }) {
    salesUser.category = category;
    salesUser.title = title;
    salesUser.price = price;
    salesUser.image = image;

    notifyListeners();
  }
}
