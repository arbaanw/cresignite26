import 'dart:io';

import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import 'craft_visual.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  Color _statusColor() {
    switch (product.status) {
      case ProductStatus.published:
        return AppColors.success;
      case ProductStatus.aiOptimized:
        return AppColors.terracotta;
      case ProductStatus.draft:
        return AppColors.charcoal.withOpacity(0.5);
    }
  }

  String _statusLabel() {
    switch (product.status) {
      case ProductStatus.published:
        return 'Published';
      case ProductStatus.aiOptimized:
        return 'AI Optimized';
      case ProductStatus.draft:
        return 'Draft';
    }
  }

  Widget _thumb(double width, double height) {
    final path = product.localImagePath;
    if (path != null && File(path).existsSync()) {
      return Image.file(File(path), width: width, height: height, fit: BoxFit.cover);
    }
    return CraftVisual(
      visualIndex: product.visual,
      enhanced: product.imageEnhanced,
      width: width,
      height: height,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: _thumb(72, 72),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₹${product.price.toStringAsFixed(0)}',
                      style: const TextStyle(color: AppColors.burgundy, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: _statusColor().withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _statusLabel(),
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _statusColor()),
                      ),
                    ),
                  ],
                ),
              ),
              if (onEdit != null || onDelete != null)
                PopupMenuButton<String>(
                  onSelected: (v) {
                    if (v == 'edit') onEdit?.call();
                    if (v == 'delete') onDelete?.call();
                  },
                  itemBuilder: (_) => [
                    if (onEdit != null) const PopupMenuItem(value: 'edit', child: Text('Edit')),
                    if (onDelete != null) const PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
