
class GeocodingUtils {
  GeocodingUtils._();

  static Future<String?> addressFromCoordinates(double lat, double lng) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isEmpty) return null;
      final p = placemarks.first;
      final parts = [
        p.street,
        p.subLocality,
        p.locality,
        p.administrativeArea,
      ].where((s) => s != null && s.isNotEmpty).toList();
      return parts.isEmpty ? null : parts.join(', ');
    } catch (_) {
      return null;
    }
  }
}
