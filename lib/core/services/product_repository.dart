import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meathub/models/product_model.dart';

class ProductRepository {
  ProductRepository._();

  static final CollectionReference<Map<String, dynamic>> _collection =
  FirebaseFirestore.instance.collection('products');

  /// Realtime stream — a price/image/stock change made in Firebase Console
  /// (or a future admin panel) reaches every user's app within moments,
  /// no app restart or redeploy needed.
  static Stream<List<ProductModel>> watchAll() {
    return _collection.snapshots().map(
          (snapshot) =>
          snapshot.docs
              .map((doc) => ProductModel.fromJson(doc.data()))
              .toList(),
    );
  }

  static Future<void> upsert(ProductModel product) {
    return _collection.doc(product.id).set(product.toJson());
  }
}