import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/demo_service.dart';
import '../theme/app_theme.dart';
import 'catalog_screen.dart';

enum _VoiceStage { idle, listening, processing, done }

class VoiceDemoScreen extends StatefulWidget {
  const VoiceDemoScreen({super.key});

  @override
  State<VoiceDemoScreen> createState() => _VoiceDemoScreenState();
}

class _VoiceDemoScreenState extends State<VoiceDemoScreen> {
  _VoiceStage _stage = _VoiceStage.idle;
  int _checks = 0;
  late final bool _hadProductAlready;

  static const _transcript = 'This is a handwoven cotton saree made in Madurai.';
  static const _resultSteps = [
    'Language detected: Tamil',
    'Product details understood',
    'Catalogue created',
  ];

  @override
  void initState() {
    super.initState();
    _hadProductAlready = context.read<AppState>().activeProduct != null;
  }

  Future<void> _start() async {
    setState(() => _stage = _VoiceStage.listening);
    await Future.delayed(const Duration(milliseconds: 1800));
    if (!mounted) return;
    setState(() => _stage = _VoiceStage.processing);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() => _stage = _VoiceStage.done);
    for (int i = 0; i < _resultSteps.length; i++) {
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;
      setState(() => _checks = i + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final finished = _stage == _VoiceStage.done && _checks == _resultSteps.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Voice Assistant')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: _stage == _VoiceStage.listening
                      ? AppColors.terracotta.withOpacity(0.18)
                      : AppColors.lavender.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _stage == _VoiceStage.listening ? Icons.mic : Icons.mic_none_outlined,
                  size: 52,
                  color: AppColors.burgundy,
                ),
              ),
              const SizedBox(height: 24),
              if (_stage == _VoiceStage.idle) ...[
                const Text('Tap the mic and describe your product',
                    textAlign: TextAlign.center, style: TextStyle(color: AppColors.textMuted)),
              ] else if (_stage == _VoiceStage.listening) ...[
                const Text('🎙 Listening...', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                const Text(
                  '"$_transcript"',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontStyle: FontStyle.italic, color: AppColors.textMuted),
                ),
              ] else if (_stage == _VoiceStage.processing) ...[
                const Text('Processing your voice...', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 16),
                const CircularProgressIndicator(color: AppColors.burgundy),
              ] else ...[
                const Text('Voice understood!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 16),
                ...List.generate(_resultSteps.length, (i) {
                  final done = i < _checks;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(done ? Icons.check_circle : Icons.circle_outlined,
                            size: 18, color: done ? AppColors.success : AppColors.charcoal.withOpacity(0.3)),
                        const SizedBox(width: 8),
                        Text(_resultSteps[i]),
                      ],
                    ),
                  );
                }),
              ],
              const Spacer(),
              if (_stage == _VoiceStage.idle)
                ElevatedButton.icon(
                  onPressed: _start,
                  icon: const Icon(Icons.mic),
                  label: const Text('Start speaking'),
                )
              else if (finished)
                ElevatedButton.icon(
                  onPressed: () {
                    final appState = context.read<AppState>();
                    if (_hadProductAlready) {
                      Navigator.of(context).pop();
                    } else {
                      if (appState.activeProduct == null) appState.startAddProduct();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const CatalogScreen()));
                    }
                  },
                  icon: Icon(_hadProductAlready ? Icons.arrow_back : Icons.arrow_forward),
                  label: Text(_hadProductAlready ? 'Back to Catalog' : 'Create Catalogue'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
