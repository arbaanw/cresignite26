import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/demo_service.dart';
import '../theme/app_theme.dart';
import '../widgets/ai_processing_view.dart';
import 'home_screen.dart';
import 'markets_screen.dart';

class PublishScreen extends StatefulWidget {
  const PublishScreen({super.key});

  @override
  State<PublishScreen> createState() => _PublishScreenState();
}

class _PublishScreenState extends State<PublishScreen> {
  bool _done = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _publish());
  }

  Future<void> _publish() async {
    await showAIProcessingDialog(
      context: context,
      title: 'Publishing your product',
      steps: const [
        'Product information',
        'Professional image',
        'Description',
        'Price',
        'Artisan profile',
      ],
    );
    if (!mounted) return;
    await context.read<AppState>().publishActiveProduct();
    if (!mounted) return;
    setState(() => _done = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: _done
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 84,
                        height: 84,
                        decoration:
                            BoxDecoration(color: AppColors.success.withOpacity(0.12), shape: BoxShape.circle),
                        child: const Icon(Icons.check, color: AppColors.success, size: 44),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Your product is market-ready.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 8),
                      const Text('Published ✓',
                          style: TextStyle(color: AppColors.burgundy, fontWeight: FontWeight.w700, fontSize: 16)),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const MarketsScreen()),
                          (route) => false,
                        ),
                        child: const Text('Explore Markets'),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const HomeScreen()),
                          (route) => false,
                        ),
                        child: const Text('Back to Home'),
                      ),
                    ],
                  )
                : const CircularProgressIndicator(color: AppColors.burgundy),
          ),
        ),
      ),
    );
  }
}
