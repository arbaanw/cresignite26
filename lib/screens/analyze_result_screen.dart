import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/analyze_result.dart';
import '../models/models.dart';
import '../services/demo_service.dart';
import '../theme/app_theme.dart';

/// Shows AI analyze output and lets the artisan edit before saving.
class AnalyzeResultScreen extends StatefulWidget {
  final File imageFile;
  final AnalyzeResult result;
  final AppLanguage language;

  const AnalyzeResultScreen({
    super.key,
    required this.imageFile,
    required this.result,
    required this.language,
  });

  @override
  State<AnalyzeResultScreen> createState() => _AnalyzeResultScreenState();
}

class _AnalyzeResultScreenState extends State<AnalyzeResultScreen> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _priceCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.result.name);
    _descCtrl = TextEditingController(text: widget.result.description);
    _priceCtrl = TextEditingController(
      text: widget.result.suggestedPrice.toStringAsFixed(0),
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final price = double.tryParse(_priceCtrl.text.trim()) ?? 0;
    await context.read<AppState>().saveAnalyzedProduct(
          name: _nameCtrl.text.trim().isEmpty ? 'Untitled craft' : _nameCtrl.text.trim(),
          description: _descCtrl.text.trim(),
          language: widget.language,
          suggestedPrice: price,
          imagePath: widget.imageFile.path,
          remoteImageUrl: widget.result.editedImageUrl,
        );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Product saved to your catalog')),
    );
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  Widget _previewImage() {
    final url = widget.result.editedImageUrl;
    if (url != null) {
      return Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Image.file(widget.imageFile, fit: BoxFit.cover),
      );
    }
    return Image.file(widget.imageFile, fit: BoxFit.cover);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI listing draft')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: AspectRatio(
              aspectRatio: 4 / 3,
              child: _previewImage(),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Review what AI found',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            'Edit anything before saving. Description language: ${widget.language.label}.',
            style: const TextStyle(color: AppColors.textMuted),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _nameCtrl,
            decoration: const InputDecoration(
              labelText: 'Object name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _descCtrl,
            minLines: 3,
            maxLines: 6,
            decoration: const InputDecoration(
              labelText: 'Short description',
              alignLabelWithHint: true,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _priceCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Suggested price (₹)',
              prefixText: '₹ ',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _save,
              child: const Text('Save to catalog'),
            ),
          ),
        ],
      ),
    );
  }
}
