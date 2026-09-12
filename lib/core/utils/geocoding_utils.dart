import 'package:geocoding/geocoding.dart';

class GeocodingUtils {
  GeocodingUtils._();

  static final Geocoding _geocoding = Geocoding();

  static Future<String?> addressFromCoordinates(double lat, double lng) async {
    try {
      final List<Placemark> placemarks = await _geocoding
          .placemarkFromCoordinates(lat, lng);
      if (placemarks.isEmpty) return null;

      final Placemark p = placemarks.first;
      final List<String> parts = <String?>[
        p.street,
        p.subLocality,
        p.locality,
        p.administrativeArea,
      ].whereType<String>().where((s) => s.trim().isNotEmpty).toList();

      return parts.isEmpty ? null : parts.join(', ');
    } catch (_) {
      return null;
    }
  }
}
