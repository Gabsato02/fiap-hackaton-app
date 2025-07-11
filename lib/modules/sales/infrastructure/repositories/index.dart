import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiap_hackaton_app/domain/entities/index.dart';

class FirestoreService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<QuerySnapshot<Map<String, dynamic>>> getStockProducts() {
    final q =
        _db.collection('stock_products').where('quantity', isGreaterThan: 0);
    return q.get();
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getUserSales(String userId) async {
    final q = _db.collection('sales').where('seller_id', isEqualTo: userId);
    return q.get();
  }

  static Future<DocumentReference<Map<String, dynamic>>> saveSale(
      Map<String, dynamic> sale) {
    return _db.collection('sales').add(sale);
  }

  static Future<void> editSale(String saleId, Map<String, dynamic> sale) {
    return _db
        .collection('sales')
        .doc(saleId)
        .set(sale, SetOptions(merge: true));
  }

  static Future<void> updateProductQuantity(String productId, int quantity) {
    final productRef = _db.collection('stock_products').doc(productId);
    return productRef.set({'quantity': quantity}, SetOptions(merge: true));
  }

  static Future<void> deleteSale(String saleId) {
    return _db.collection('sales').doc(saleId).delete();
  }
}
