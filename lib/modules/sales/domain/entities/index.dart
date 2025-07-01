class Product {
  final String id;
  final String name;
  final double price;

  Product({required this.id, required this.name, required this.price});
}

class Sale {
  final String id;
  final String productId;
  final int quantity;
  final String date;

  Sale(
      {required this.id,
      required this.productId,
      required this.quantity,
      required this.date});
}
