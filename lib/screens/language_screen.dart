import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../services/demo_service.dart';
import '../theme/app_theme.dart';
import '../widgets/cribeit_logo.dart';
import 'onboarding_screen.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  AppLanguage _selected = AppLanguage.english;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const CribeItLogo(size: 44, color: AppColors.burgundy),
              const SizedBox(height: 20),
              const Text('Choose your language', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              const Text(
                'மொழியைத் தேர்ந்தெடுக்கவும் · भाषा चुनें',
                style: TextStyle(color: AppColors.textMuted),
              ),
              const SizedBox(height: 28),
              Expanded(
                child: ListView(
                  children: AppLanguage.values.map((lang) {
                    final selected = lang == _selected;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () => setState(() => _selected = lang),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                          decoration: BoxDecoration(
                            color: selected ? AppColors.burgundy.withOpacity(0.08) : Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: selected ? AppColors.burgundy : AppColors.charcoal.withOpacity(0.1),
                              width: selected ? 1.6 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  lang.label,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: selected ? AppColors.burgundy : AppColors.charcoal,
                                  ),
                                ),
                              ),
                              if (selected) const Icon(Icons.check_circle, color: AppColors.burgundy),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<AppState>().setLanguage(_selected);
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const OnboardingScreen()));
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
