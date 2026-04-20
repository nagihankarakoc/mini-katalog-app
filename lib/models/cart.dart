class Cart {
  static final List<Map> items = [];

  static double get totalPrice {
    double total = 0;
    for (var item in items) {
      // JSON'dan gelen sayıyı double'a çeviriyoruz
      var price = item["price"];
      if (price is num) {
        total += price.toDouble();
      } else if (price is String) {
        total += double.tryParse(price) ?? 0.0;
      }
    }
    return total;
  }
}
