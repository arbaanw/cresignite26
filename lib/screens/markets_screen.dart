import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../services/demo_service.dart';
import '../theme/app_theme.dart';

class MarketsScreen extends StatelessWidget {
  final bool embedded;
  const MarketsScreen({super.key, this.embedded = false});

  @override
  Widget build(BuildContext context) {
    final buyers = context.watch<AppState>().buyers;

    final content = SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (embedded) ...[
            const Text('Markets', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
            const SizedBox(height: 16),
          ],
          const Text('B2B Opportunities', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          ...buyers.map((b) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _BuyerCard(buyer: b),
              )),
          const SizedBox(height: 12),
          const Text('Government / Digital Marketplace', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(color: AppColors.lavender.withOpacity(0.2), borderRadius: BorderRadius.circular(18)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.public, color: AppColors.burgundy),
                    SizedBox(width: 10),
                    Expanded(child: Text('Explore supported marketplaces', style: TextStyle(fontWeight: FontWeight.w700))),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'ONDC, GeM and state emporiums — a simulated demo connection, not a live integration.',
                  style: TextStyle(color: AppColors.textMuted),
                ),
                const SizedBox(height: 14),
                OutlinedButton(
                  onPressed: () => _showDemoConnection(context),
                  child: const Text('Connect (Demo)'),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    if (embedded) return content;
    return Scaffold(appBar: AppBar(title: const Text('Markets')), body: content);
  }

  void _showDemoConnection(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Simulated connection'),
        content: const Text(
          'This is a hackathon demo. In a live version, CribeIt would securely connect your catalog to ONDC / GeM digital marketplaces.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('Got it')),
        ],
      ),
    );
  }
}

class _BuyerCard extends StatelessWidget {
  final Buyer buyer;
  const _BuyerCard({required this.buyer});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.charcoal.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: AppColors.terracotta.withOpacity(0.14), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.storefront, color: AppColors.terracotta),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(buyer.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                    Text(buyer.type, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text('Interested in: ${buyer.interest}', style: const TextStyle(color: AppColors.textMuted)),
          const SizedBox(height: 4),
          Text('Minimum order: ${buyer.minOrder} pieces', style: const TextStyle(color: AppColors.textMuted)),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton(
              onPressed: () => _showOpportunity(context, buyer),
              child: const Text('View Opportunity'),
            ),
          ),
        ],
      ),
    );
  }

  void _showOpportunity(BuildContext context, Buyer buyer) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(buyer.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Type: ${buyer.type}'),
            const SizedBox(height: 6),
            Text('Interested in: ${buyer.interest}'),
            const SizedBox(height: 6),
            Text('Minimum order: ${buyer.minOrder} pieces'),
            const SizedBox(height: 12),
            const Text(
              'This is a simulated buyer for demo purposes.',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: AppColors.textMuted),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('Close')),
        ],
      ),
    );
  }
}
