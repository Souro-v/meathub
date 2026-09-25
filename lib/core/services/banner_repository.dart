import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meathub/models/banner_model.dart';

class BannerRepository {
  BannerRepository._();

  static final CollectionReference<Map<String, dynamic>> _collection =
      FirebaseFirestore.instance.collection('banners');

  static Stream<List<BannerModel>> watchAll() {
    return _collection.snapshots().map((snapshot) {
      final list = snapshot.docs
          .map((doc) => BannerModel.fromJson(doc.data()))
          .toList();
      list.sort((a, b) => a.order.compareTo(b.order));
      return list;
    });
  }

  static Future<void> upsert(BannerModel banner) {
    return _collection.doc(banner.id).set(banner.toJson());
  }
}
