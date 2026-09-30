import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../services/api_service.dart';
import '../services/demo_service.dart';
import '../theme/app_theme.dart';
import '../widgets/craft_visual.dart';
import 'analyze_result_screen.dart';
import 'image_studio_screen.dart';
import 'voice_demo_screen.dart';

class AddProductScreen extends StatefulWidget {
  final bool embedded;
  const AddProductScreen({super.key, this.embedded = false});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _picker = ImagePicker();
  final _api = ApiService();
  bool _analyzing = false;

  void _selectSeededProduct() {
    context.read<AppState>().startAddProduct();
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ImageStudioScreen()));
  }

  Future<void> _pickAndAnalyze(ImageSource source) async {
    if (_analyzing) return;

    final picked = await _picker.pickImage(
      source: source,
      maxWidth: 1600,
      maxHeight: 1600,
      imageQuality: 85,
    );
    if (picked == null || !mounted) return;

    final language = context.read<AppState>().language;
    setState(() => _analyzing = true);

    try {
      final result = await _api.analyzeProduct(
        imageFile: File(picked.path),
        languageCode: language.code,
      );
      if (!mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => AnalyzeResultScreen(
            imageFile: File(picked.path),
            result: result,
            language: language,
          ),
        ),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      _showError(e.message);
    } catch (e) {
      if (!mounted) return;
      _showError(
        'Could not reach the analyze API at ${_api.baseUrl}.\n'
        'Start the FastAPI server, then try again.\n\n$e',
      );
    } finally {
      if (mounted) setState(() => _analyzing = false);
    }
  }

  void _showError(String message) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Analyze failed'),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final content = Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Add a product', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              const Text(
                'Take or upload a photo — AI will name it, describe it, and suggest a price.',
                style: TextStyle(color: AppColors.textMuted),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _analyzing ? null : () => _pickAndAnalyze(ImageSource.camera),
                      icon: const Icon(Icons.photo_camera_outlined),
                      label: const Text('Take Photo'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _analyzing ? null : () => _pickAndAnalyze(ImageSource.gallery),
                      icon: const Icon(Icons.photo_library_outlined),
                      label: const Text('Upload'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const VoiceDemoScreen()),
                ),
                icon: const Icon(Icons.mic_none_outlined),
                label: const Text('Describe by Voice'),
              ),
              const SizedBox(height: 28),
              const Text('Offline demo path', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              const Text(
                'Uses the seeded saree flow without the backend.',
                style: TextStyle(fontSize: 12, color: AppColors.textMuted),
              ),
              const SizedBox(height: 12),
              InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: _selectSeededProduct,
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.charcoal.withOpacity(0.08)),
                  ),
                  child: const Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(14)),
                        child: CraftVisual(visualIndex: 0, width: 64, height: 64),
                      ),
                      SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Handwoven Cotton Saree', style: TextStyle(fontWeight: FontWeight.w700)),
                            SizedBox(height: 4),
                            Text(
                              'Tap for the original offline demo',
                              style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right, color: AppColors.burgundy),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_analyzing)
          Positioned.fill(
            child: ColoredBox(
              color: Colors.black.withOpacity(0.35),
              child: const Center(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 28, vertical: 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Analyzing your craft…', style: TextStyle(fontWeight: FontWeight.w600)),
                        SizedBox(height: 4),
                        Text(
                          'Name · description · price',
                          style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );

    if (widget.embedded) return content;
    return Scaffold(appBar: AppBar(title: const Text('Add Product')), body: content);
  }
}
