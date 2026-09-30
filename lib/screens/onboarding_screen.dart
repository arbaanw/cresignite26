import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../services/demo_service.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final TextEditingController _name;
  late final TextEditingController _craft;
  late final TextEditingController _location;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: 'Lakshmi Devi');
    _craft = TextEditingController(text: 'Handwoven Textiles');
    _location = TextEditingController(text: 'Madurai, Tamil Nadu');
  }

  @override
  void dispose() {
    _name.dispose();
    _craft.dispose();
    _location.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: const Text('Your profile')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Tell us about your craft', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              const Text(
                'This helps CribeIt personalise your business assistant.',
                style: TextStyle(color: AppColors.textMuted),
              ),
              const SizedBox(height: 28),
              const Text('Name', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(controller: _name),
              const SizedBox(height: 18),
              const Text('Craft', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(controller: _craft),
              const SizedBox(height: 18),
              const Text('Location', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(controller: _location),
              const SizedBox(height: 18),
              const Text('Language', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.charcoal.withOpacity(0.12)),
                ),
                child: Row(
                  children: [
                    Expanded(child: Text(appState.language.label)),
                    const Icon(Icons.language, color: AppColors.burgundy, size: 18),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () async {
                  final artisan = Artisan(
                    name: _name.text.trim().isEmpty ? 'Lakshmi Devi' : _name.text.trim(),
                    craft: _craft.text.trim().isEmpty ? 'Handwoven Textiles' : _craft.text.trim(),
                    location: _location.text.trim().isEmpty ? 'Madurai, Tamil Nadu' : _location.text.trim(),
                    language: appState.language,
                  );
                  await context.read<AppState>().completeOnboarding(artisan);
                  if (!context.mounted) return;
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                    (route) => false,
                  );
                },
                child: const Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
