import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../services/demo_service.dart';
import '../theme/app_theme.dart';
import '../widgets/ai_processing_view.dart';
import 'pricing_screen.dart';
import 'voice_demo_screen.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    final product = context.read<AppState>().activeProduct;
    for (final lang in AppLanguage.values) {
      _controllers[lang.code] = TextEditingController(text: product?.descriptionFor(lang) ?? '');
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _regenerate() async {
    await showAIProcessingDialog(
      context: context,
      title: 'Regenerating catalog',
      steps: const [
        'Analyzing enhanced photo',
        'Understanding craft details',
        'Writing descriptions',
        'Translating to Hindi & Tamil',
      ],
    );
  }

  void _saveDescriptions() {
    final appState = context.read<AppState>();
    for (final lang in AppLanguage.values) {
      appState.updateActiveDescription(lang, _controllers[lang.code]!.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = context.watch<AppState>().activeProduct;
    if (product == null) {
      return const Scaffold(body: Center(child: Text('No product selected.')));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Catalog'),
        actions: [
          IconButton(
            tooltip: 'Voice demo',
            icon: const Icon(Icons.mic_none_outlined),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const VoiceDemoScreen())),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(product.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),
              _infoRow('Category', product.category),
              _infoRow('Material', product.material),
              _infoRow('Craft', product.craft),
              _infoRow('Origin', product.origin),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: product.keywords.map((k) => Chip(label: Text(k))).toList(),
              ),
              const SizedBox(height: 20),
              const Text('Description', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.charcoal.withOpacity(0.1)),
                ),
                child: TabBar(
                  controller: _tabController,
                  labelColor: AppColors.burgundy,
                  unselectedLabelColor: AppColors.charcoal.withOpacity(0.5),
                  indicatorColor: AppColors.burgundy,
                  tabs: const [Tab(text: 'English'), Tab(text: 'हिन्दी'), Tab(text: 'தமிழ்')],
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 160,
                child: TabBarView(
                  controller: _tabController,
                  children: AppLanguage.values.map((lang) {
                    return TextField(
                      controller: _controllers[lang.code],
                      maxLines: 6,
                      onChanged: (_) => _saveDescriptions(),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _regenerate,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Regenerate'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _saveDescriptions();
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PricingScreen()));
                      },
                      icon: const Icon(Icons.check),
                      label: const Text('Save'),
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

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(width: 90, child: Text(label, style: const TextStyle(color: AppColors.textMuted))),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }
}
