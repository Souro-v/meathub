import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meathub/models/category_model.dart';

class CategoryRepository {
  CategoryRepository._();

  static final CollectionReference<Map<String, dynamic>> _collection =
      FirebaseFirestore.instance.collection('categories');

  static Stream<List<CategoryModel>> watchAll() {
    return _collection.snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => CategoryModel.fromJson(doc.data()))
          .toList(),
    );
  }

  static Future<void> upsert(CategoryModel category) {
    return _collection.doc(category.name).set(category.toJson());
  }
}
