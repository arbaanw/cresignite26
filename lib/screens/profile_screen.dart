import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/demo_service.dart';
import '../theme/app_theme.dart';
import 'language_screen.dart';
import '../models/models.dart';

class ProfileScreen extends StatelessWidget {
  final bool embedded;
  const ProfileScreen({super.key, this.embedded = false});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final artisan = appState.artisan;

    final content = SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (embedded) ...[
            const Text('Profile', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
            const SizedBox(height: 20),
          ],
          Center(
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(color: AppColors.lavender.withOpacity(0.3), shape: BoxShape.circle),
                  child: const Icon(Icons.person, size: 40, color: AppColors.burgundy),
                ),
                const SizedBox(height: 14),
                Text(artisan.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(artisan.location, style: const TextStyle(color: AppColors.textMuted)),
                Text(artisan.craft, style: const TextStyle(color: AppColors.textMuted)),
                Text(artisan.language.code, style: const TextStyle(color: AppColors.textMuted)),
              ],
            ),
          ),
          const SizedBox(height: 28),
          _tile(context, Icons.storefront_outlined, 'My Business',
              () => _showInfo(context, 'My Business', '${artisan.craft} · ${artisan.location}\n\nManage your craft business details here.')),
          _tile(context, Icons.language, 'Language',
              () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LanguageScreen()))),
          _tile(context, Icons.help_outline, 'Help',
              () => _showInfo(context, 'Help',
                  'Need help using CribeIt? This demo build covers adding products, AI enhancement, catalog translation, pricing, listing and publishing.')),
          _tile(context, Icons.info_outline, 'About CribeIt',
              () => _showInfo(context, 'About CribeIt',
                  'CribeIt is an AI-powered virtual business assistant helping Indian artisans digitize and sell their products.\n\nFrom Craft to Commerce.')),
        ],
      ),
    );

    if (embedded) return content;
    return Scaffold(appBar: AppBar(title: const Text('Profile')), body: content);
  }

  Widget _tile(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: AppColors.burgundy),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  void _showInfo(BuildContext context, String title, String body) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('Close'))],
      ),
    );
  }
}
