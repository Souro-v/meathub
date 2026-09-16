import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';
import 'package:meathub/models/address_model.dart';
import 'package:meathub/providers/addresses_provider.dart';
import '../../core/widgets/custom_textfield.dart';

class AddNewAddressSheet extends StatefulWidget {
  const AddNewAddressSheet({super.key});

  @override
  State<AddNewAddressSheet> createState() => _AddNewAddressSheetState();
}

class _AddNewAddressSheetState extends State<AddNewAddressSheet> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _houseController = TextEditingController();
  final _roadController = TextEditingController();
  final _areaController = TextEditingController();
  final _landmarkController = TextEditingController();

  String _selectedType = 'Home';
  bool _makeDefault = true;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _houseController.dispose();
    _roadController.dispose();
    _areaController.dispose();
    _landmarkController.dispose();
    super.dispose();
  }

  IconData get _typeIcon {
    switch (_selectedType) {
      case 'Home':
        return Icons.home;
      case 'Office':
        return Icons.apartment;
      default:
        return Icons.more_horiz;
    }
  }

  Color get _typeColor =>
      _selectedType == 'Home' ? AppColors.primary : AppColors.textDark;

  Color get _typeBg =>
      _selectedType == 'Home' ? AppColors.primarySoft : AppColors.surface;

  void _submit() {
    if (_nameController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty ||
        _houseController.text.trim().isEmpty ||
        _roadController.text.trim().isEmpty ||
        _areaController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    final parts = [
      _houseController.text.trim(),
      _roadController.text.trim(),
      _areaController.text.trim(),
      if (_landmarkController.text.trim().isNotEmpty)
        _landmarkController.text.trim(),
    ];

    final address = ManagedAddressModel(
      id: 'addr_${DateTime.now().microsecondsSinceEpoch}',
      label: _selectedType,
      labelIcon: _typeIcon,
      labelColor: _typeColor,
      labelBg: _typeBg,
      name: _nameController.text.trim(),
      phone: '+880 ${_phoneController.text.trim()}',
      address: parts.join(', '),
      isDefault: _makeDefault,
    );

    context.read<AddressesProvider>().addAddress(address);
    Navigator.of(context).maybePop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Address saved'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppColors.divider,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            AppStrings.addNewAddress,
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textDark,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            AppStrings.addNewAddressSubtitle,
                            style: TextStyle(
                              fontSize: 12.5,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
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
                  ],
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  icon: Icons.person_outline,
                  hint: AppStrings.fullNameHint,
                  controller: _nameController,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  icon: Icons.call_outlined,
                  hint: AppStrings.mobileNumberHint,
                  keyboardType: TextInputType.phone,
                  controller: _phoneController,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  icon: Icons.home_outlined,
                  hint: AppStrings.houseFlatHint,
                  controller: _houseController,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  icon: Icons.route_outlined,
                  hint: AppStrings.roadStreetHint,
                  controller: _roadController,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  icon: Icons.location_on_outlined,
                  hint: AppStrings.areaHint,
                  controller: _areaController,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  icon: Icons.flag_outlined,
                  hint: AppStrings.landmarkOptionalHint,
                  controller: _landmarkController,
                ),
                const SizedBox(height: 18),
                const Text(
                  AppStrings.addressType,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _AddressTypeButton(
                        icon: Icons.home,
                        label: AppStrings.addressTypeHome,
                        selected: _selectedType == 'Home',
                        onTap: () => setState(() => _selectedType = 'Home'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _AddressTypeButton(
                        icon: Icons.apartment,
                        label: AppStrings.addressTypeOffice,
                        selected: _selectedType == 'Office',
                        onTap: () => setState(() => _selectedType = 'Office'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _AddressTypeButton(
                        icon: Icons.more_horiz,
                        label: AppStrings.addressTypeOther,
                        selected: _selectedType == 'Other',
                        onTap: () => setState(() => _selectedType = 'Other'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const Text(
                  AppStrings.mapPreview,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 10),
                _buildMapPreview(),
                const SizedBox(height: 16),
                Row(
                  children: [
                    SizedBox(
                      width: 22,
                      height: 22,
                      child: Checkbox(
                        value: _makeDefault,
                        activeColor: AppColors.primary,
                        onChanged: (v) =>
                            setState(() => _makeDefault = v ?? false),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        AppStrings.makeDefaultCheckbox,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _submit,
                    icon: const Icon(Icons.save_outlined, size: 18),
                    label: const Text(AppStrings.saveAddress),
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
                const SizedBox(height: 8),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    child: const Text(
                      AppStrings.cancel,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMapPreview() {
    return Stack(
      children: [
        Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFE9E9EA),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Center(
            child: Icon(Icons.location_on, color: AppColors.primary, size: 34),
          ),
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 4),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.my_location, size: 14, color: AppColors.primary),
                SizedBox(width: 6),
                Text(
                  AppStrings.pinMyLocation,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AddressTypeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _AddressTypeButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.divider,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: selected ? AppColors.white : AppColors.textDark,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: selected ? AppColors.white : AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
