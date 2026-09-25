import 'dart:async';
import 'package:flutter/material.dart';
import 'package:meathub/core/services/banner_repository.dart';
import 'package:meathub/models/banner_model.dart';

class BannerProvider extends ChangeNotifier {
  List<BannerModel> _banners = [];
  StreamSubscription<List<BannerModel>>? _sub;
  bool _isLoading = true;

  BannerProvider() {
    _sub = BannerRepository.watchAll().listen(
      (banners) {
        _banners = banners;
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

  List<BannerModel> get banners => List.unmodifiable(_banners);

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
