import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiap_hackaton_app/domain/entities/index.dart';
import 'package:fiap_hackaton_app/domain/entities/production.dart';

class FirestoreService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<QuerySnapshot<Map<String, dynamic>>> getStockProducts() {
    final q =
        _db.collection('stock_products').where('quantity', isGreaterThan: 0);
    return q.get();
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getAllStockProducts() {
    return _db.collection('stock_products').orderBy('name').get();
  }

  static Future<void> addProduct(Map<String, dynamic> data) {
    return _db.collection('stock_products').add(data);
  }

  static Future<void> updateProduct(String id, Map<String, dynamic> data) {
    return _db.collection('stock_products').doc(id).update(data);
  }

  static Future<void> deleteProduct(String id) {
    return _db.collection('stock_products').doc(id).delete();
  }

  static Future<void> updateProductQuantity(String productId, int quantity) {
    final productRef = _db.collection('stock_products').doc(productId);
    return productRef.set({'quantity': quantity}, SetOptions(merge: true));
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getUserSales(
      String userId) async {
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

  static Future<void> deleteSale(String saleId) {
    return _db.collection('sales').doc(saleId).delete();
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getProductions() {
    return _db
        .collection('productions')
        .orderBy('creationDate', descending: true)
        .get();
  }

  static Future<DocumentReference<Map<String, dynamic>>> addProduction(
      Map<String, dynamic> data) {
    return _db.collection('productions').add({
      ...data,
      'creationDate': Timestamp.now(),
    });
  }

  static Future<void> updateProduction(String id, Map<String, dynamic> data) {
    return _db.collection('productions').doc(id).update(data);
  }

  static Future<void> updateProductionStatus(
      String productionId, String status) {
    return _db
        .collection('productions')
        .doc(productionId)
        .update({'status': status});
  }

  static Future<void> harvestProduction(Production productionItem) {
    final productRef =
        _db.collection('stock_products').doc(productionItem.productId);
    final productionRef = _db.collection('productions').doc(productionItem.id);

    return _db.runTransaction((transaction) async {
      final productSnapshot = await transaction.get(productRef);

      if (!productSnapshot.exists) {
        throw Exception("Produto no estoque não encontrado!");
      }

      final currentStock = productSnapshot.data()!['quantity'] as int;
      final newStock = currentStock + productionItem.quantity;

      transaction.update(productRef, {'quantity': newStock});
      transaction.update(productionRef, {'status': 'harvested'});
    });
  }
}
