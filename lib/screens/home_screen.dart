import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/demo_service.dart';
import '../theme/app_theme.dart';
import '../widgets/cribeit_logo.dart';
import 'add_product_screen.dart';
import 'products_screen.dart';
import 'markets_screen.dart';
import 'profile_screen.dart';
import 'voice_demo_screen.dart';
import 'assistant_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  final List<Widget> _tabs = const [
    _HomeTab(),
    ProductsScreen(embedded: true),
    SizedBox.shrink(),
    MarketsScreen(embedded: true),
    ProfileScreen(embedded: true),
  ];

  void goToTab(int i) {
    if (i == 2) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AddProductScreen()));
      return;
    }
    setState(() => _index = i);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: IndexedStack(index: _index, children: _tabs)),
      floatingActionButton: _index == 0
          ? FloatingActionButton.extended(
              onPressed: () =>
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AssistantScreen())),
              backgroundColor: AppColors.burgundy,
              icon: const Icon(Icons.smart_toy_outlined, color: Colors.white),
              label: const Text('Assistant', style: TextStyle(color: Colors.white)),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index == 2 ? 0 : _index,
        onDestinationSelected: goToTab,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.grid_view_outlined), selectedIcon: Icon(Icons.grid_view), label: 'Products'),
          NavigationDestination(icon: Icon(Icons.add_circle_outline), selectedIcon: Icon(Icons.add_circle), label: 'Add'),
          NavigationDestination(icon: Icon(Icons.storefront_outlined), selectedIcon: Icon(Icons.storefront), label: 'Markets'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final artisan = appState.artisan;
    final firstName = artisan.name.trim().isEmpty ? 'Artisan' : artisan.name.trim().split(' ').first;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 90),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Good morning, $firstName 👋',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    const Text('Your digital business assistant', style: TextStyle(color: AppColors.textMuted)),
                  ],
                ),
              ),
              const CribeItLogo(size: 34, color: AppColors.burgundy),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _StatCard(label: 'Products', value: '${appState.products.length}')),
              const SizedBox(width: 10),
              Expanded(child: _StatCard(label: 'Published', value: '${appState.publishedCount}')),
              const SizedBox(width: 10),
              Expanded(child: _StatCard(label: 'Inventory Value', value: '₹${appState.inventoryValue.toStringAsFixed(0)}')),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Quick actions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AddProductScreen())),
            icon: const Icon(Icons.add_a_photo_outlined),
            label: const Text('Add Product'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const VoiceDemoScreen())),
            icon: const Icon(Icons.mic_none_outlined),
            label: const Text('Describe by Voice'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => context.findAncestorStateOfType<_HomeScreenState>()?.goToTab(1),
            icon: const Icon(Icons.grid_view_outlined),
            label: const Text('My Products'),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.lavender.withOpacity(0.22),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.auto_awesome, color: AppColors.burgundy),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('AI Insight', style: TextStyle(fontWeight: FontWeight.w700)),
                      SizedBox(height: 4),
                      Text(
                        'Products with enhanced photos sell up to 2x faster. Try the AI Image Studio!',
                        style: TextStyle(color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.charcoal.withOpacity(0.08)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textMuted), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
