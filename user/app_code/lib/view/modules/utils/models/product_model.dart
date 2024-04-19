import 'category_data_model.dart';

class ProductModel {
  List<CategoryDataModel> Products;
  List Categories;
  int itemsLength;
  bool isShimmer;

  ProductModel({
    required this.Products,
    required this.Categories,
    required this.itemsLength,
    required this.isShimmer,
  });
}
