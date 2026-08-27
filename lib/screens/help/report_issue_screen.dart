import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';
import 'package:meathub/core/routes/app_routes.dart';
import 'package:meathub/core/utils/image_picker_utils.dart';
import 'package:meathub/core/widgets/dotted_border_box.dart';
import 'package:meathub/core/widgets/hero_info_banner.dart';
import 'package:meathub/core/widgets/issue_type_grid_card.dart';
import 'package:meathub/providers/orders_provider.dart';
import 'package:meathub/providers/ticket_provider.dart';

class ReportIssueScreen extends StatefulWidget {
  final String? orderId;
  final String? presetIssueType;

  const ReportIssueScreen({super.key, this.orderId, this.presetIssueType});

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  static const List<Map<String, dynamic>> _issueTypes = [
    {
      'icon': Icons.inventory_2_outlined,
      'label': 'Wrong Item',
      'color': Color(0xFFB71C1C),
    },
    {
      'icon': Icons.broken_image_outlined,
      'label': 'Damaged Item',
      'color': Color(0xFFB2560A),
    },
    {
      'icon': Icons.help_outline,
      'label': 'Missing Item',
      'color': Color(0xFF6A4FBF),
    },
    {
      'icon': Icons.thumb_down_outlined,
      'label': 'Poor Quality',
      'color': Color(0xFF2E7D32),
    },
    {
      'icon': Icons.two_wheeler,
      'label': 'Delivery Issue',
      'color': Color(0xFFEF6C00),
    },
    {
      'icon': Icons.more_horiz,
      'label': 'Other Issue',
      'color': AppColors.textHint,
    },
  ];

  late String _selectedType;
  final _descController = TextEditingController();
  final List<File> _photos = [];
  String? _selectedOrderId;

  @override
  void initState() {
    super.initState();
    _selectedType =
        widget.presetIssueType ?? _issueTypes.first['label'] as String;
    _selectedOrderId = widget.orderId;
  }

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  Future<void> _addPhoto() async {
    if (_photos.length >= 5) return;
    final file = await ImagePickerUtils.pickFromGallery();
    if (file != null) setState(() => _photos.add(file));
  }

  void _pickOrder() {
    final orders = context.read<OrdersProvider>().orders;
    showModalBottomSheet(
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
                  AppStrings.selectOrderLabel,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 12),
                ...orders.map(
                  (o) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        o.items.first.product.image,
                        width: 44,
                        height: 44,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      o.orderId,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                      '৳${o.total.toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    onTap: () {
                      setState(() => _selectedOrderId = o.orderId);
                      Navigator.pop(sheetContext);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _submit() {
    final ticket = context.read<TicketProvider>().createTicket(
      title: _selectedType,
      orderId: _selectedOrderId,
      initialMessage: _descController.text.trim().isEmpty
          ? _selectedType
          : _descController.text.trim(),
      imagePath: _photos.isNotEmpty ? _photos.first.path : null,
    );
    Navigator.of(
      context,
    ).pushReplacement(AppRoutes.issueSubmittedRoute(ticket.id));
  }

  @override
  Widget build(BuildContext context) {
    final selectedOrder = _selectedOrderId != null
        ? context.watch<OrdersProvider>().findById(_selectedOrderId!)
        : null;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HeroInfoBanner(
                      icon: Icons.assignment_outlined,
                      title: AppStrings.facingAProblemTitle,
                      description: AppStrings.facingAProblemDesc,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      AppStrings.selectAnIssueType,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _issueTypes.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 0.92,
                          ),
                      itemBuilder: (context, index) {
                        final type = _issueTypes[index];
                        return IssueTypeGridCard(
                          icon: type['icon'] as IconData,
                          iconColor: type['color'] as Color,
                          label: type['label'] as String,
                          selected: _selectedType == type['label'],
                          onTap: () => setState(
                            () => _selectedType = type['label'] as String,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      AppStrings.orderDetailsOptional,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (widget.orderId != null && selectedOrder != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                selectedOrder.items.first.product.image,
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '${selectedOrder.orderId} • ৳${selectedOrder.total.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textDark,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      InkWell(
                        onTap: _pickOrder,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.divider),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  selectedOrder != null
                                      ? '${selectedOrder.orderId} • ৳${selectedOrder.total.toStringAsFixed(0)}'
                                      : AppStrings.selectOrderOptional,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textDark,
                                  ),
                                ),
                              ),
                              const Text(
                                AppStrings.choose,
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                              const Icon(
                                Icons.chevron_right,
                                size: 16,
                                color: AppColors.primary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 20),
                    const Text(
                      AppStrings.tellUsMore,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _descController,
                      maxLines: 4,
                      maxLength: 500,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: AppStrings.describeIssuePlaceholder,
                        hintStyle: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textHint,
                        ),
                        filled: true,
                        fillColor: AppColors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: AppColors.divider,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: AppColors.divider,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      AppStrings.addPhotosOptional,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      AppStrings.addClearPhotosDesc,
                      style: TextStyle(fontSize: 12, color: AppColors.textHint),
                    ),
                    const SizedBox(height: 10),
                    if (_photos.isNotEmpty) ...[
                      SizedBox(
                        height: 64,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _photos.length,
                          separatorBuilder: (_, _) => const SizedBox(width: 10),
                          itemBuilder: (context, index) => ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              _photos[index],
                              width: 64,
                              height: 64,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                    if (_photos.length < 5)
                      InkWell(
                        onTap: _addPhoto,
                        borderRadius: BorderRadius.circular(14),
                        child: DottedBorderBox(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.camera_alt_outlined,
                                size: 26,
                                color: AppColors.textHint,
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                AppStrings.tapToAddPhotos,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textDark,
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                AppStrings.upToFivePhotos,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textHint,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submit,
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
                        child: const Text(AppStrings.submitIssue),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: const [
                        Icon(
                          Icons.shield_outlined,
                          size: 14,
                          color: AppColors.textHint,
                        ),
                        SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            AppStrings.reviewedWithin24h,
                            textAlign: TextAlign.center,
                            style: TextStyle(
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
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
      child: Row(
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
          const SizedBox(width: 2),
          const Text(
            AppStrings.reportAnIssueTitle,
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}
