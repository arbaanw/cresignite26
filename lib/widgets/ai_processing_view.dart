import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Shows a modal dialog that animates through a list of "AI" processing
/// steps, one checkmark at a time, then closes itself. Reused across
/// image enhancement, catalog generation, pricing and publishing.
Future<void> showAIProcessingDialog({
  required BuildContext context,
  required String title,
  required List<String> steps,
  Duration stepDuration = const Duration(milliseconds: 650),
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => AIProcessingDialog(title: title, steps: steps, stepDuration: stepDuration),
  );
}

class AIProcessingDialog extends StatefulWidget {
  final String title;
  final List<String> steps;
  final Duration stepDuration;

  const AIProcessingDialog({
    super.key,
    required this.title,
    required this.steps,
    this.stepDuration = const Duration(milliseconds: 650),
  });

  @override
  State<AIProcessingDialog> createState() => _AIProcessingDialogState();
}

class _AIProcessingDialogState extends State<AIProcessingDialog> {
  int _visibleSteps = 0;

  @override
  void initState() {
    super.initState();
    _run();
  }

  Future<void> _run() async {
    for (int i = 0; i < widget.steps.length; i++) {
      await Future.delayed(widget.stepDuration);
      if (!mounted) return;
      setState(() => _visibleSteps = i + 1);
    }
    await Future.delayed(const Duration(milliseconds: 450));
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2.6, color: AppColors.burgundy),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ...List.generate(widget.steps.length, (i) {
              final done = i < _visibleSteps;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Icon(
                      done ? Icons.check_circle : Icons.circle_outlined,
                      size: 18,
                      color: done ? AppColors.success : AppColors.charcoal.withOpacity(0.3),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        widget.steps[i],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: done ? FontWeight.w600 : FontWeight.w400,
                          color: done ? AppColors.charcoal : AppColors.charcoal.withOpacity(0.55),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
