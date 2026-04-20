class Product {
  final String title;
  final String image;
  final double price;

  Product({required this.title, required this.image, required this.price});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      title: json['title'],
      image: json['thumbnail'], // DummyJSON
      price: json['price'].toDouble(),
    );
  }
}
