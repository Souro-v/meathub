import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';
import 'package:meathub/core/routes/app_routes.dart';
import 'package:meathub/core/widgets/radio_option_tile.dart';
import 'package:meathub/data/dummy_issue_options.dart';
import 'package:meathub/providers/ticket_provider.dart';

class RefundRequestScreen extends StatefulWidget {
  final String orderId;

  const RefundRequestScreen({super.key, required this.orderId});

  @override
  State<RefundRequestScreen> createState() => _RefundRequestScreenState();
}

class _RefundRequestScreenState extends State<RefundRequestScreen> {
  late String _selectedReason;
  late String _selectedMethodId;

  @override
  void initState() {
    super.initState();
    _selectedReason = DummyIssueOptions.refundReasons.first;
    _selectedMethodId = DummyIssueOptions.refundMethods.first.id;
  }

  void _submit() {
    final method = DummyIssueOptions.refundMethods.firstWhere(
      (m) => m.id == _selectedMethodId,
    );
    final ticket = context.read<TicketProvider>().createTicket(
      title: 'Refund Request',
      orderId: widget.orderId,
      initialMessage:
          'Reason: $_selectedReason\nRefund method: ${method.title}',
    );
    Navigator.of(
      context,
    ).pushReplacement(AppRoutes.ticketDetailRoute(ticket.id));
  }

  @override
  Widget build(BuildContext context) {
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
                    const Text(
                      AppStrings.selectRefundReason,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...DummyIssueOptions.refundReasons.map(
                      (reason) => RadioOptionTile(
                        title: reason,
                        selected: _selectedReason == reason,
                        onTap: () => setState(() => _selectedReason = reason),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      AppStrings.refundMethod,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...DummyIssueOptions.refundMethods.map(
                      (method) => RadioOptionTile(
                        title: method.title,
                        subtitle: method.subtitle,
                        selected: _selectedMethodId == method.id,
                        onTap: () =>
                            setState(() => _selectedMethodId = method.id),
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
                        child: const Text(AppStrings.submitRequest),
                      ),
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
                children: [
                  const Text(
                    AppStrings.requestRefundTitle,
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${AppStrings.orderIdLabel}: ${widget.orderId}',
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
