import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../services/demo_service.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';

class ProductsScreen extends StatelessWidget {
  final bool embedded;
  const ProductsScreen({super.key, this.embedded = false});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final products = appState.products;

    final list = products.isEmpty
        ? const Center(child: Text('No products yet. Add your first product!'))
        : ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: products.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductCard(
                product: product,
                onTap: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => ProductDetailScreen(productId: product.id))),
                onEdit: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => ProductDetailScreen(productId: product.id))),
                onDelete: () => _confirmDelete(context, product),
              );
            },
          );

    if (embedded) {
      return Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(
              children: [
                Expanded(child: Text('My Products', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800))),
              ],
            ),
          ),
          Expanded(child: list),
        ],
      );
    }

    return Scaffold(appBar: AppBar(title: const Text('My Products')), body: list);
  }

  void _confirmDelete(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete product?'),
        content: Text('This will remove "${product.name}" from your catalog.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              context.read<AppState>().deleteProduct(product.id);
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
