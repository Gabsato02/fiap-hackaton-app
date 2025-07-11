// ignore_for_file: non_constant_identifier_names

class Product {
  final String id;
  final String name;
  final int price;
  final int quantity;

  Product(
      {required this.id,
      required this.name,
      required this.price,
      required this.quantity});

  factory Product.fromJson(String $id, Map<String, dynamic> json) {
    return Product(
      id: $id,
      name: json['name'] ?? '',
      price: json['price'] ?? 0,
      quantity: json['quantity'] ?? 0,
    );
  }
}

class Sale {
  final String? id;
  final String date;
  final int total_price;
  final int product_price;
  final int product_quantity;
  final String product_name;
  final String product_id;
  final String seller_id;
  final String? sale_id;

  Sale({
      this.id,
      required this.date,
      required this.total_price,
      required this.product_name,
      required this.product_price,
      required this.product_quantity,
      required this.product_id,
      required this.seller_id,
      this.sale_id});

  factory Sale.fromJson(String $id, Map<String, dynamic> json) {
    return Sale(
      id: $id,
      date: json['date'] ?? '',
      product_name: json['product_name'] ?? '',
      total_price: json['total_price'] ?? 0,
      product_price: json['product_price'] ?? 0,
      product_quantity: json['product_quantity'] ?? 0,
      product_id: json['product_id'] ?? '',
      seller_id: json['seller_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'product_name': product_name,
      'total_price': total_price,
      'product_price': product_price,
      'product_quantity': product_quantity,
      'product_id': product_id,
      'seller_id': seller_id,
    };
  }
}

class UserInfo {
  final String? email;
  final String? name;
  final String? photoUrl;
  final String id;

  UserInfo({
    required this.id,
    this.email,
    this.name,
    this.photoUrl,
  });
}
