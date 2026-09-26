import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meathub/models/coupon_model.dart';

class CouponRepository {
  CouponRepository._();

  static final CollectionReference<Map<String, dynamic>> _collection =
      FirebaseFirestore.instance.collection('coupons');

  static Stream<List<CouponModel>> watchAll() {
    return _collection.snapshots().map(
      (snapshot) =>
          snapshot.docs.map((doc) => CouponModel.fromJson(doc.data())).toList(),
    );
  }

  static Future<void> upsert(CouponModel coupon) {
    return _collection.doc(coupon.code).set(coupon.toJson());
  }
}
