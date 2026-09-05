import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';
import 'package:meathub/core/utils/geocoding_utils.dart';
import 'package:meathub/core/utils/location_utils.dart';

class UseCurrentLocationSheet extends StatefulWidget {
  final void Function(String address)? onLocationResolved;

  const UseCurrentLocationSheet({super.key, this.onLocationResolved});

  @override
  State<UseCurrentLocationSheet> createState() =>
      _UseCurrentLocationSheetState();
}

class _UseCurrentLocationSheetState extends State<UseCurrentLocationSheet> {
  bool _loading = false;
  String? _errorMessage;
  bool _permanentlyDenied = false;

  Future<void> _allowLocationAccess() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
      _permanentlyDenied = false;
    });

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _loading = false;
        _errorMessage =
            'Location services are turned off. Please enable GPS and try again.';
      });
      return;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      setState(() {
        _loading = false;
        _errorMessage = 'Location permission denied.';
      });
      return;
    }
    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _loading = false;
        _permanentlyDenied = true;
        _errorMessage =
            'Location permission permanently denied. Please enable it from app settings.';
      });
      return;
    }

    final position = await LocationUtils.getCurrentPosition();
    if (!mounted) return;
    if (position == null) {
      setState(() {
        _loading = false;
        _errorMessage = "Couldn't detect your location. Please try again.";
      });
      return;
    }

    final address = await GeocodingUtils.addressFromCoordinates(
      position.latitude,
      position.longitude,
    );
    if (!mounted) return;

    final resolvedAddress = (address != null && address.isNotEmpty)
        ? address
        : '${position.latitude.toStringAsFixed(5)}, ${position.longitude.toStringAsFixed(5)}';

    setState(() => _loading = false);
    widget.onLocationResolved?.call(resolvedAddress);
    Navigator.of(context).maybePop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Location detected: $resolvedAddress'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.divider,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () => Navigator.of(context).maybePop(),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.surface,
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 17,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildPinGraphic(),
              const SizedBox(height: 18),
              const Text(
                AppStrings.useCurrentLocationTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                AppStrings.useCurrentLocationSubtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
              if (_errorMessage == null)
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.primarySoft,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.white,
                        ),
                        child: const Icon(
                          Icons.shield_outlined,
                          color: AppColors.primary,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.locationPermissionRequired,
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              AppStrings.locationPermissionDesc,
                              style: TextStyle(
                                fontSize: 12.5,
                                color: AppColors.textSecondary,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFCE4E4),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: AppColors.error,
                        size: 18,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: AppColors.error,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _loading ? null : _allowLocationAccess,
                  icon: _loading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(AppColors.white),
                          ),
                        )
                      : const Icon(Icons.my_location, size: 18),
                  label: Text(
                    _loading ? 'Detecting...' : AppStrings.allowLocationAccess,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    minimumSize: const Size(0, 54),
                    textStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _permanentlyDenied
                      ? () => Geolocator.openAppSettings()
                      : () => Navigator.of(context).maybePop(),
                  icon: Icon(
                    _permanentlyDenied
                        ? Icons.settings_outlined
                        : Icons.location_on_outlined,
                    size: 18,
                  ),
                  label: Text(
                    _permanentlyDenied
                        ? 'Open App Settings'
                        : AppStrings.chooseAddressManually,
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textDark,
                    side: const BorderSide(color: AppColors.divider),
                    minimumSize: const Size(0, 54),
                    textStyle: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.verified_user_outlined,
                    size: 14,
                    color: AppColors.textHint,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      AppStrings.locationPrivacyNote,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: AppColors.textHint,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPinGraphic() {
    return SizedBox(
      height: 130,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 130,
            height: 130,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surface,
            ),
          ),
          Positioned(
            bottom: 18,
            child: Container(
              width: 60,
              height: 14,
              decoration: BoxDecoration(
                color: AppColors.divider.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          const Positioned(
            bottom: 30,
            child: Icon(Icons.location_on, color: AppColors.primary, size: 62),
          ),
        ],
      ),
    );
  }
}
