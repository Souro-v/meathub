import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meathub/core/constants/app_colors.dart';
import 'package:meathub/core/constants/app_strings.dart';
import 'package:meathub/core/routes/app_routes.dart';
import 'package:meathub/core/widgets/ticket_card.dart';
import 'package:meathub/providers/ticket_provider.dart';

class TicketListScreen extends StatefulWidget {
  const TicketListScreen({super.key});

  @override
  State<TicketListScreen> createState() => _TicketListScreenState();
}

class _TicketListScreenState extends State<TicketListScreen> {
  bool _showOpen = true;

  @override
  Widget build(BuildContext context) {
    final ticketProvider = context.watch<TicketProvider>();
    final open = ticketProvider.openTickets;
    final resolved = ticketProvider.resolvedTickets;
    final list = _showOpen ? open : resolved;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(child: _TabButton(label: '${AppStrings.openLabel} (${open.length})', selected: _showOpen, onTap: () => setState(() => _showOpen = true))),
                  const SizedBox(width: 10),
                  Expanded(child: _TabButton(label: '${AppStrings.resolvedLabel} (${resolved.length})', selected: !_showOpen, onTap: () => setState(() => _showOpen = false))),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: list.isEmpty
                  ? Center(child: Text(_showOpen ? AppStrings.noOpenTickets : AppStrings.noResolvedTickets, style: const TextStyle(fontSize: 13, color: AppColors.textHint)))
                  : ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                itemCount: list.length,
                itemBuilder: (context, index) => TicketCard(
                  ticket: list[index],
                  onTap: () => Navigator.of(context).push(AppRoutes.ticketDetailRoute(list[index].id)),
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
            child: const Padding(padding: EdgeInsets.all(8), child: Icon(Icons.arrow_back, size: 22, color: AppColors.textDark)),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(AppStrings.mySupportTicketsTitle, style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: AppColors.textDark)),
                  SizedBox(height: 2),
                  Text(AppStrings.trackAllSupportConversations, style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TabButton({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? AppColors.primary : AppColors.divider),
        ),
        child: Text(label, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: selected ? AppColors.white : AppColors.textDark)),
      ),
    );
  }
}