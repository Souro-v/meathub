import 'package:flutter/material.dart';
import 'package:meathub/core/services/firestore_service.dart';
import 'package:meathub/data/dummy_addresses.dart';
import 'package:meathub/models/address_model.dart';

class AddressesProvider extends ChangeNotifier {
  final List<ManagedAddressModel> _addresses = [];
  bool _loaded = false;

  AddressesProvider() {
    _addresses.addAll(DummyAddresses.managed);
  }

  List<ManagedAddressModel> get addresses => List.unmodifiable(_addresses);

  ManagedAddressModel? get defaultAddress {
    if (_addresses.isEmpty) return null;
    try {
      return _addresses.firstWhere((a) => a.isDefault);
    } catch (_) {
      return _addresses.first;
    }
  }

  Future<void> loadFromFirestore() async {
    if (_loaded) return;
    _loaded = true;
    final raw = await FirestoreService.loadList('addresses');
    // Same rule as OrdersProvider — never let the demo seed leak into a
    // real account. A brand-new user genuinely starts with zero addresses.
    _addresses.clear();
    _addresses.addAll(raw.map((e) => ManagedAddressModel.fromJson(e)));
    notifyListeners();
  }

  void _persist() {
    FirestoreService.saveList(
      'addresses',
      _addresses.map((a) => a.toJson()).toList(),
    );
  }

  void addAddress(ManagedAddressModel address) {
    final shouldBeDefault = address.isDefault || _addresses.isEmpty;
    if (shouldBeDefault) {
      for (var i = 0; i < _addresses.length; i++) {
        _addresses[i] = _addresses[i].copyWith(isDefault: false);
      }
    }
    _addresses.add(
      shouldBeDefault ? address.copyWith(isDefault: true) : address,
    );
    notifyListeners();
    _persist();
  }

  void removeAddress(String id) {
    final wasDefault = _addresses.any((a) => a.id == id && a.isDefault);
    _addresses.removeWhere((a) => a.id == id);
    if (wasDefault && _addresses.isNotEmpty) {
      _addresses[0] = _addresses[0].copyWith(isDefault: true);
    }
    notifyListeners();
    _persist();
  }

  void setDefault(String id) {
    for (var i = 0; i < _addresses.length; i++) {
      _addresses[i] = _addresses[i].copyWith(isDefault: _addresses[i].id == id);
    }
    notifyListeners();
    _persist();
  }

  void reset() {
    _addresses.clear();
    _loaded = false;
    notifyListeners();
  }
}
