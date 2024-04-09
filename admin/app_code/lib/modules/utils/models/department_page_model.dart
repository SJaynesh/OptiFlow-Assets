import 'dart:io';

class DepartmentPageModel {
  File? image;
  String title;
  int price;
  int qty;
  String category;
  String description;
  String? department;

  DepartmentPageModel({
    required this.image,
    required this.title,
    required this.price,
    required this.qty,
    required this.category,
    required this.description,
    required this.department,
  });

  Map<String, dynamic> toMap() {
    return {
      "image": image?.path,
      "title": title,
      "price": price,
      "qty": qty,
      "category": category,
      "description": description,
      "department": department,
    };
  }
}
