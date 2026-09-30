import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/demo_service.dart';
import '../theme/app_theme.dart';

class AssistantScreen extends StatefulWidget {
  const AssistantScreen({super.key});

  @override
  State<AssistantScreen> createState() => _AssistantScreenState();
}

class _ChatMessage {
  final String text;
  final bool fromUser;
  _ChatMessage(this.text, this.fromUser);
}

class _AssistantScreenState extends State<AssistantScreen> {
  final List<_ChatMessage> _messages = [
    _ChatMessage("Hi! I'm your CribeIt Assistant. Ask me anything about your business.", false),
  ];

  static const _questions = [
    'How much should I sell this?',
    'Make my description better.',
    'Show my products.',
    'Show me buyers.',
    'Translate this.',
  ];

  String _answerFor(String question) {
    final appState = context.read<AppState>();
    switch (question) {
      case 'How much should I sell this?':
        return 'Based on your demo pricing model, your Handwoven Cotton Saree is recommended at ₹2,850 (range ₹2,500–₹3,200).';
      case 'Make my description better.':
        return 'Try highlighting the craft technique, region and material — e.g. "Handwoven in Madurai using 100% cotton with traditional patterns."';
      case 'Show my products.':
        return 'You have ${appState.products.length} products, with ${appState.publishedCount} published so far.';
      case 'Show me buyers.':
        return 'There are ${appState.buyers.length} B2B buyers interested in your craft category right now. Check the Markets tab.';
      case 'Translate this.':
        return 'I can translate your catalog descriptions into Hindi and Tamil from the AI Catalog screen — just switch tabs there.';
      default:
        return "I'm still learning that one, but I can help with pricing, descriptions, products and buyers!";
    }
  }

  void _ask(String question) {
    setState(() {
      _messages.add(_ChatMessage(question, true));
      _messages.add(_ChatMessage(_answerFor(question), false));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CribeIt Assistant')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  return Align(
                    alignment: msg.fromUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                      decoration: BoxDecoration(
                        color: msg.fromUser ? AppColors.burgundy : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: msg.fromUser ? null : Border.all(color: AppColors.charcoal.withOpacity(0.1)),
                      ),
                      child: Text(msg.text, style: TextStyle(color: msg.fromUser ? Colors.white : AppColors.charcoal)),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _questions.map((q) => ActionChip(label: Text(q), onPressed: () => _ask(q))).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
