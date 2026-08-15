import 'package:flutter/material.dart';
import 'package:meathub/models/coupon_model.dart';

class CouponProvider extends ChangeNotifier {
  CouponModel? _appliedCoupon;
  bool _justApplied = false;

  CouponModel? get appliedCoupon => _appliedCoupon;

  void apply(CouponModel coupon) {
    _appliedCoupon = coupon;
    _justApplied = true;
    notifyListeners();
  }

  void remove() {
    _appliedCoupon = null;
    notifyListeners();
  }

  bool consumeJustApplied() {
    if (_justApplied) {
      _justApplied = false;
      return true;
    }
    return false;
  }
}