import 'dart:developer';

import 'package:app_code/view/modules/utils/models/product_model.dart';
import 'package:flutter/material.dart';

import '../models/category_data_model.dart';

class ProductController extends ChangeNotifier {
  ProductModel productModel = ProductModel(
    Products: [],
    Categories: [],
    itemsLength: 0,
  );

  void getProductData({required List<CategoryDataModel> productData}) {
    productModel.Products = productData;
    notifyListeners();
  }

  void getProductAvailableItems() {
    productModel.itemsLength = productModel.Products.length;
    log("===============================");
    log("Items : ${productModel.itemsLength}");
    log("===============================");
    notifyListeners();
  }

  void getCategoryData({required List categoryData}) {
    productModel.Categories = categoryData;
    notifyListeners();
  }

  // void getEarningAndSales({required int qty, required double price}) {
  //   productModel.sales += qty;
  //   double total = price * qty;
  //   productModel.earning += total;
  //   notifyListeners();
  // }
}
