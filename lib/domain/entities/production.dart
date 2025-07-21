import 'package:cloud_firestore/cloud_firestore.dart';

class Production {
  final String id;
  final String productId;
  final String productName;
  final int quantity;
  final String status;
  final DateTime creationDate;

  Production({
    required this.id,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.status,
    required this.creationDate,
  });

  factory Production.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    dynamic creationDateData = data['creationDate'];
    DateTime parsedCreationDate;

    if (creationDateData is Timestamp) {
      parsedCreationDate = creationDateData.toDate();
    } else if (creationDateData is String) {
      parsedCreationDate =
          DateTime.tryParse(creationDateData) ?? DateTime.now();
    } else {
      parsedCreationDate = DateTime.now();
    }

    return Production(
      id: doc.id,
      productId: data['productId'] ?? '',
      productName: data['productName'] ?? '',
      quantity: data['quantity'] ?? 0,
      status: data['status'] ?? 'waiting',
      creationDate: parsedCreationDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'status': status,
      'creationDate': Timestamp.fromDate(creationDate),
    };
  }
}
