import 'package:flutter/material.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';
import 'package:meathub/core/utils/date_format_utils.dart';
import 'package:meathub/core/utils/order_utils.dart';
import 'package:meathub/models/ticket_model.dart';

class TicketCard extends StatelessWidget {
  final TicketModel ticket;
  final VoidCallback onTap;

  const TicketCard({super.key, required this.ticket, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isOpen = ticket.status == TicketStatus.open;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        ticket.id,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isOpen
                              ? AppColors.successSoft
                              : AppColors.surface,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          isOpen
                              ? AppStrings.openLabel
                              : AppStrings.resolvedLabel,
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: isOpen
                                ? AppColors.success
                                : AppColors.textHint,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    ticket.title,
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  if (ticket.orderId != null) ...[
                    const SizedBox(height: 3),
                    Text(
                      '${AppStrings.orderIdLabel}: ${ticket.orderId}',
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: AppColors.textHint,
                      ),
                    ),
                  ],
                  const SizedBox(height: 6),
                  Text(
                    'Created on ${DateFormatUtils.formatFullDate(ticket.createdAt)}, ${OrderUtils.formatTime(ticket.createdAt)}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textHint,
                    ),
                  ),
                  Text(
                    '${isOpen ? 'Last reply' : 'Resolved on'}: ${DateFormatUtils.formatFullDate(ticket.lastReplyAt)}, ${OrderUtils.formatTime(ticket.lastReplyAt)}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Padding(
              padding: EdgeInsets.only(top: 4),
              child: Icon(
                Icons.chevron_right,
                size: 18,
                color: AppColors.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
