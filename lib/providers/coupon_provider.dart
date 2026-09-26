import 'dart:async';
import 'package:flutter/material.dart';
import 'package:meathub/core/services/coupon_repository.dart';
import 'package:meathub/models/coupon_model.dart';

class CouponProvider extends ChangeNotifier {
  CouponModel? _appliedCoupon;
  bool _justApplied = false;
  List<CouponModel> _allCoupons = [];
  StreamSubscription<List<CouponModel>>? _sub;
  bool _isLoading = true;

  CouponProvider() {
    _sub = CouponRepository.watchAll().listen(
      (coupons) {
        _allCoupons = coupons;
        _isLoading = false;
        notifyListeners();
      },
      onError: (_) {
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  bool get isLoading => _isLoading;

  List<CouponModel> get allCoupons => List.unmodifiable(_allCoupons);

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

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
