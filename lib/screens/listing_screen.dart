import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/demo_service.dart';
import '../theme/app_theme.dart';
import '../widgets/craft_visual.dart';
import 'catalog_screen.dart';
import 'publish_screen.dart';

class ListingScreen extends StatelessWidget {
  const ListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final product = appState.activeProduct;
    if (product == null) {
      return const Scaffold(body: Center(child: Text('No product selected.')));
    }
    final description = product.descriptionFor(appState.language);

    return Scaffold(
      appBar: AppBar(title: const Text('Listing Preview')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: CraftVisual(
                  visualIndex: product.visual,
                  enhanced: product.imageEnhanced,
                  width: double.infinity,
                  height: 220,
                ),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, size: 14, color: AppColors.success),
                    SizedBox(width: 4),
                    Text('AI Optimized', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.success)),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(product.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Text('₹${product.price.toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.burgundy)),
              const SizedBox(height: 4),
              Text(product.category, style: const TextStyle(color: AppColors.textMuted)),
              const SizedBox(height: 16),
              Text(description),
              const SizedBox(height: 16),
              _detailRow('Material', product.material),
              _detailRow('Craft', product.craft),
              _detailRow('Origin', product.origin),
              const SizedBox(height: 10),
              Wrap(spacing: 8, runSpacing: 8, children: product.keywords.map((k) => Chip(label: Text(k))).toList()),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CatalogScreen())),
                      icon: const Icon(Icons.edit_outlined),
                      label: const Text('Edit Listing'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PublishScreen())),
                      icon: const Icon(Icons.publish_outlined),
                      label: const Text('Publish'),
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

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 90, child: Text(label, style: const TextStyle(color: AppColors.textMuted))),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }
}
