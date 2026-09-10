import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meathub/core/services/auth_service.dart';

class FirestoreService {
  FirestoreService._();

  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static DocumentReference<Map<String, dynamic>>? get _userDoc {
    final uid = AuthService.currentUser?.uid;
    if (uid == null) return null;
    return _db.collection('users').doc(uid);
  }

  static Future<void> saveList(String key,
      List<Map<String, dynamic>> items) async {
    final doc = _userDoc;
    if (doc == null) return;
    await doc.set({key: items}, SetOptions(merge: true));
  }

  static Future<List<Map<String, dynamic>>> loadList(String key) async {
    final doc = _userDoc;
    if (doc == null) return [];
    final snapshot = await doc.get();
    final data = snapshot.data();
    if (data == null || data[key] == null) return [];
    return List<Map<String, dynamic>>.from(
      (data[key] as List).map((e) => Map<String, dynamic>.from(e as Map)),
    );
  }

  static Future<void> saveMap(String key, Map<String, dynamic> value) async {
    final doc = _userDoc;
    if (doc == null) return;
    await doc.set({key: value}, SetOptions(merge: true));
  }

  static Future<Map<String, dynamic>?> loadMap(String key) async {
    final doc = _userDoc;
    if (doc == null) return null;
    final snapshot = await doc.get();
    final data = snapshot.data();
    if (data == null || data[key] == null) return null;
    return Map<String, dynamic>.from(data[key] as Map);
  }
}