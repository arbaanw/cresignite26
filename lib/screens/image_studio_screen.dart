import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/demo_service.dart';
import '../theme/app_theme.dart';
import '../widgets/ai_processing_view.dart';
import '../widgets/craft_visual.dart';
import 'catalog_screen.dart';

class ImageStudioScreen extends StatefulWidget {
  const ImageStudioScreen({super.key});

  @override
  State<ImageStudioScreen> createState() => _ImageStudioScreenState();
}

class _ImageStudioScreenState extends State<ImageStudioScreen> {
  bool _processed = false;
  bool _processing = false;

  Future<void> _startProcessing() async {
    setState(() => _processing = true);
    await showAIProcessingDialog(
      context: context,
      title: 'AI Image Studio',
      steps: const [
        'Analyzing image',
        'Detecting product',
        'Removing background',
        'Improving lighting',
        'Optimizing composition',
      ],
    );
    if (!mounted) return;
    setState(() {
      _processing = false;
      _processed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final product = context.watch<AppState>().activeProduct;
    if (product == null) {
      return const Scaffold(body: Center(child: Text('No product selected.')));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('AI Image Studio')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(product.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              const Text('Original → AI Enhanced', style: TextStyle(color: AppColors.textMuted)),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: CraftVisual(visualIndex: product.visual, width: double.infinity, height: 170),
                        ),
                        const SizedBox(height: 8),
                        const Text('Original', style: TextStyle(fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: _processed
                              ? CraftVisual(
                                  visualIndex: product.visual,
                                  enhanced: true,
                                  width: double.infinity,
                                  height: 170,
                                )
                              : Container(
                                  height: 170,
                                  decoration: BoxDecoration(
                                    color: AppColors.charcoal.withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(color: AppColors.charcoal.withOpacity(0.1)),
                                  ),
                                  child: Icon(Icons.auto_awesome_outlined,
                                      color: AppColors.charcoal.withOpacity(0.25), size: 40),
                                ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Enhanced',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: _processed ? AppColors.burgundy : AppColors.charcoal.withOpacity(0.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              if (!_processed)
                ElevatedButton.icon(
                  onPressed: _processing ? null : _startProcessing,
                  icon: const Icon(Icons.auto_fix_high),
                  label: const Text('Start AI Enhancement'),
                )
              else
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<AppState>().markImageEnhanced();
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CatalogScreen()));
                  },
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Use Enhanced Image'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
