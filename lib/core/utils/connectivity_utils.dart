import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityUtils {
  ConnectivityUtils._();

  static Future<bool> isConnected() async {
    final results = await Connectivity().checkConnectivity();
    return results.any((r) => r != ConnectivityResult.none);
  }
}
