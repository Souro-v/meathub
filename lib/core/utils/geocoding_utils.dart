import 'package:geocoding/geocoding.dart';
import 'package:geocoding/geocoding.dart' as geocoding;

class GeocodingUtils {
  GeocodingUtils._();

  static Future<String?> addressFromCoordinates(double lat, double lng) async {
    try {
      final List<geocoding.Placemark> placemarks = await geocoding
          .placemarkFromCoordinates(lat, lng);
      if (placemarks.isEmpty) return null;

      final geocoding.Placemark p = placemarks.first;
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
