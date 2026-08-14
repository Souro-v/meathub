import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';
import 'package:meathub/core/utils/date_format_utils.dart';
import 'package:meathub/core/utils/image_picker_utils.dart';
import 'package:meathub/core/widgets/user_avatar.dart';
import 'package:meathub/data/dummy_addresses.dart';
import 'package:meathub/providers/user_provider.dart';
import 'package:meathub/screens/address/address_selection_screen.dart';

import '../../core/widgets/custom_textfield.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late DateTime? _dateOfBirth;
  late String? _gender;

  @override
  void initState() {
    super.initState();
    final user = context.read<UserProvider>();
    _nameController = TextEditingController(text: user.name);
    _phoneController = TextEditingController(text: user.phone);
    _emailController = TextEditingController(text: user.email);
    _dateOfBirth = user.dateOfBirth;
    _gender = user.gender;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final file = await ImagePickerUtils.pickFromGallery();
    if (file != null && mounted) {
      context.read<UserProvider>().updatePhoto(file);
    }
  }

  Future<void> _pickDateOfBirth() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _dateOfBirth = picked);
  }

  Future<void> _pickGender() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  AppStrings.selectGender,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                for (final option in [
                  AppStrings.genderMale,
                  AppStrings.genderFemale,
                  AppStrings.genderOther,
                ])
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(option),
                    trailing: _gender == option
                        ? const Icon(Icons.check, color: AppColors.primary)
                        : null,
                    onTap: () => Navigator.pop(sheetContext, option),
                  ),
              ],
            ),
          ),
        );
      },
    );
    if (result != null) setState(() => _gender = result);
  }

  void _handleSave() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Full name cannot be empty')),
      );
      return;
    }
    final email = _emailController.text.trim();
    if (email.isNotEmpty && !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email')),
      );
      return;
    }

    context.read<UserProvider>().updateProfile(
      name: name,
      phone: _phoneController.text.trim(),
      email: email,
      dateOfBirth: _dateOfBirth,
      gender: _gender,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(AppStrings.profileUpdated),
        backgroundColor: AppColors.primary,
      ),
    );
    Navigator.of(context).maybePop();
  }

  void _confirmDeleteAccount() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(AppStrings.deleteAccountConfirmTitle),
        content: const Text(AppStrings.deleteAccountConfirmDesc),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(AppStrings.no),
          ),
          TextButton(
            onPressed: () => Navigator.of(
              dialogContext,
            ).pushNamedAndRemoveUntil('/login', (route) => false),
            child: const Text(
              AppStrings.deleteAccount,
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label — ${AppStrings.comingSoon}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final defaultAddress = DummyAddresses.managed.firstWhere(
      (a) => a.isDefault,
      orElse: () => DummyAddresses.managed.first,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPhotoCard(),
                    const SizedBox(height: 16),
                    _buildPersonalInfoCard(),
                    const SizedBox(height: 16),
                    _buildPreferencesCard(context, defaultAddress),
                    const SizedBox(height: 16),
                    _buildSecurityCard(),
                    const SizedBox(height: 16),
                    _buildDeleteAccountCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => Navigator.of(context).maybePop(),
            borderRadius: BorderRadius.circular(20),
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(
                Icons.arrow_back,
                size: 22,
                color: AppColors.textDark,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    AppStrings.editProfileTitle,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    AppStrings.editProfileSubtitle,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _handleSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              textStyle: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(AppStrings.save),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoCard() {
    final user = context.watch<UserProvider>();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            AppStrings.profilePhoto,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Stack(
                children: [
                  const UserAvatar(radius: 34),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: _pickPhoto,
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.divider),
                        ),
                        child: const Icon(
                          Icons.camera_alt_outlined,
                          size: 13,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      AppStrings.photoRequirements,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: AppColors.textHint,
                      ),
                    ),
                  ],
                ),
              ),
              OutlinedButton.icon(
                onPressed: _pickPhoto,
                icon: const Icon(Icons.camera_alt_outlined, size: 14),
                label: const Text(AppStrings.changePhoto),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            AppStrings.personalInformation,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 14),
          CustomTextField(
            icon: Icons.person_outline,
            hint: AppStrings.fullNameLabel,
            label: AppStrings.fullNameLabel,
            controller: _nameController,
          ),
          const SizedBox(height: 14),
          CustomTextField(
            icon: Icons.call_outlined,
            hint: AppStrings.phoneNumberLabel,
            label: AppStrings.phoneNumberLabel,
            keyboardType: TextInputType.phone,
            controller: _phoneController,
          ),
          const SizedBox(height: 14),
          CustomTextField(
            icon: Icons.mail_outline,
            hint: AppStrings.emailAddressLabel,
            label: AppStrings.emailAddressLabel,
            keyboardType: TextInputType.emailAddress,
            controller: _emailController,
          ),
          const SizedBox(height: 14),
          _TappableField(
            icon: Icons.calendar_today_outlined,
            label: AppStrings.dateOfBirthLabel,
            value: _dateOfBirth != null
                ? DateFormatUtils.formatFullDate(_dateOfBirth!)
                : 'Select date',
            onTap: _pickDateOfBirth,
          ),
          const SizedBox(height: 14),
          _TappableField(
            icon: Icons.person_outline,
            label: AppStrings.genderLabel,
            value: _gender ?? AppStrings.selectGender,
            onTap: _pickGender,
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesCard(BuildContext context, dynamic defaultAddress) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          const SizedBox(height: 14),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              AppStrings.preferences,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
          ),
          _MenuRow(
            icon: Icons.location_on_outlined,
            title: AppStrings.defaultDeliveryAddress,
            subtitle: defaultAddress.address,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AddressSelectionScreen()),
            ),
          ),
          const Divider(color: AppColors.divider, height: 1),
          _MenuRow(
            icon: Icons.notifications_outlined,
            title: AppStrings.notificationPreferences,
            subtitle: AppStrings.notificationPreferencesDesc,
            onTap: () => _showComingSoon(AppStrings.notificationPreferences),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          const SizedBox(height: 14),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              AppStrings.security,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
          ),
          _MenuRow(
            icon: Icons.lock_outline,
            title: AppStrings.changePassword,
            subtitle: AppStrings.changePasswordDesc,
            onTap: () => _showComingSoon(AppStrings.changePassword),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteAccountCard() {
    return InkWell(
      onTap: _confirmDeleteAccount,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.primarySoft,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.delete_outline,
                size: 18,
                color: AppColors.error,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.deleteAccount,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.error,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    AppStrings.deleteAccountDesc,
                    style: TextStyle(
                      fontSize: 11.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 18, color: AppColors.error),
          ],
        ),
      ),
    );
  }
}

class _TappableField extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  const _TappableField({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: AppColors.textDark),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.divider),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Icon(icon, size: 18, color: AppColors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  size: 20,
                  color: AppColors.textHint,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MenuRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MenuRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                color: AppColors.primarySoft,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 17, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 18,
              color: AppColors.textHint,
            ),
          ],
        ),
      ),
    );
  }
}
