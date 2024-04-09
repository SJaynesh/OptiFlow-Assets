class CategoryDataModel {
  String title;
  int price;
  int qty;
  String category;
  String des;
  String image;

  CategoryDataModel({
    required this.title,
    required this.price,
    required this.qty,
    required this.category,
    required this.des,
    required this.image,
  });

  factory CategoryDataModel.fromMap({required Map<String, dynamic> data}) {
    return CategoryDataModel(
      title: data['title'],
      price: data['price'],
      qty: data['qty'],
      category: data['category'],
      des: data['description'],
      image: data['image'],
    );
  }

  Map<String, dynamic> toMap() => {
        'title': title,
        'price': price,
        'qty': qty,
        'category': category,
        'des': des,
        'image': image,
      };
}
