import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../services/demo_service.dart';
import '../theme/app_theme.dart';
import '../widgets/ai_processing_view.dart';
import 'listing_screen.dart';

class PricingScreen extends StatefulWidget {
  const PricingScreen({super.key});

  @override
  State<PricingScreen> createState() => _PricingScreenState();
}

class _PricingScreenState extends State<PricingScreen> {
  late TextEditingController _materialCtrl;
  late TextEditingController _daysCtrl;
  late TextEditingController _otherCtrl;
  PricingRecommendation? _result;
  bool _processing = false;

  @override
  void initState() {
    super.initState();
    final product = context.read<AppState>().activeProduct;
    _materialCtrl = TextEditingController(text: (product?.rawMaterialCost ?? 1200).toStringAsFixed(0));
    _daysCtrl = TextEditingController(text: (product?.craftingDays ?? 3).toString());
    _otherCtrl = TextEditingController(text: (product?.otherCosts ?? 300).toStringAsFixed(0));
  }

  @override
  void dispose() {
    _materialCtrl.dispose();
    _daysCtrl.dispose();
    _otherCtrl.dispose();
    super.dispose();
  }

  Future<void> _runAssistant() async {
    setState(() => _processing = true);
    await showAIProcessingDialog(
      context: context,
      title: 'AI Price Assistant',
      steps: const [
        'Analyzing product',
        'Checking material cost',
        'Studying demo market data',
        'Calculating price',
      ],
    );
    if (!mounted) return;
    final material = double.tryParse(_materialCtrl.text) ?? 1200;
    final days = int.tryParse(_daysCtrl.text) ?? 3;
    final other = double.tryParse(_otherCtrl.text) ?? 300;
    final rec = context
        .read<AppState>()
        .calculatePricing(materialCost: material, craftingDays: days, otherCosts: other);
    setState(() {
      _result = rec;
      _processing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final result = _result;
    return Scaffold(
      appBar: AppBar(title: const Text('Smart Pricing')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Your costs', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 16),
              _numberField('Raw Material Cost (₹)', _materialCtrl),
              const SizedBox(height: 12),
              _numberField('Crafting Time (days)', _daysCtrl),
              const SizedBox(height: 12),
              _numberField('Other Costs (₹)', _otherCtrl),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _processing ? null : _runAssistant,
                icon: const Icon(Icons.auto_awesome),
                label: const Text('AI Price Assistant'),
              ),
              if (result != null) ...[
                const SizedBox(height: 28),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: AppColors.burgundy, borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    children: [
                      Text(
                        '₹${result.recommended.toStringAsFixed(0)}',
                        style: const TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 4),
                      const Text('Recommended Selling Price', style: TextStyle(color: Colors.white70)),
                      const SizedBox(height: 8),
                      Text(
                        'Range: ₹${result.rangeLow.toStringAsFixed(0)} – ₹${result.rangeHigh.toStringAsFixed(0)}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Demo market analysis (simulated, not real external market data)',
                  style: TextStyle(fontSize: 12, color: AppColors.textMuted, fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 12),
                _reasonRow('Material Cost', result.materialCost),
                _reasonRow('Craftsmanship', result.craftsmanship),
                _reasonRow('Market Pattern', result.marketPattern),
                _reasonRow('Suggested Margin', result.margin),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    final material = double.tryParse(_materialCtrl.text) ?? 1200;
                    final days = int.tryParse(_daysCtrl.text) ?? 3;
                    final other = double.tryParse(_otherCtrl.text) ?? 300;
                    context.read<AppState>().applyPricing(
                          result,
                          materialCost: material,
                          craftingDays: days,
                          otherCosts: other,
                        );
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ListingScreen()));
                  },
                  child: Text('Use ₹${result.recommended.toStringAsFixed(0)}'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _numberField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(controller: controller, keyboardType: TextInputType.number),
      ],
    );
  }

  Widget _reasonRow(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textMuted)),
          Text('₹${value.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
