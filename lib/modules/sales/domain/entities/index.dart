class Product {
  final String id;
  final String name;
  final double price;

  Product({required this.id, required this.name, required this.price});
}

class Sale {
  final String id;
  final String date;
  final String totalPrice;
  final int productPrice;
  final int productQuantity;
  final String productId;
  final String sellerId;

  Sale(
      {required this.id,
      required this.date,
      required this.totalPrice,
      required this.productPrice,
      required this.productQuantity,
      required this.productId,
      required this.sellerId});
}
