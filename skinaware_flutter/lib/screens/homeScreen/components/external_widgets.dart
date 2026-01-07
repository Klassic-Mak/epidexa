import 'package:flutter/material.dart';

class AssistantSuggestionsWidget extends StatelessWidget {
  const AssistantSuggestionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFFF7ED), // light cream background
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HistoryCard(
            iconColor: const Color(0xFFFFD6A5),
            title: 'Pasta Carbonara Recipe',
            subtitle: 'Yesterday at 6:30 PM',
            statusText: 'Completed',
            statusColor: const Color(0xFFD1FAE5),
            time: '15 min',
          ),
          const SizedBox(height: 12),
          _HistoryCard(
            iconColor: const Color(0xFFE5F0FF),
            title: 'Kitchen Deep Clean Guide',
            subtitle: '2 days ago',
            statusText: 'Completed',
            statusColor: const Color(0xFFD1FAE5),
            time: '45 min',
          ),
          const SizedBox(height: 12),
          _HistoryCard(
            iconColor: const Color(0xFFE9D5FF),
            title: 'Morning Routine Plan',
            subtitle: '3 days ago',
            statusText: 'Saved',
            statusColor: const Color(0xFFE0E7FF),
            time: '30 min',
          ),
          const SizedBox(height: 24),
          const Text(
            'Try Asking Me...',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          _SuggestionTile(
            color: const Color(0xFFFFEDD5),
            text: 'What should I cook for dinner tonight?',
          ),
          _SuggestionTile(
            color: const Color(0xFFE0F2FE),
            text: 'Help me clean the house step by step',
          ),
          _SuggestionTile(
            color: const Color(0xFFEDE9FE),
            text: 'Create a weekly meal plan for my family',
          ),
          _SuggestionTile(
            color: const Color(0xFFDCFCE7),
            text: 'I want to learn how to bake bread',
          ),
        ],
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final Color iconColor;
  final String title;
  final String subtitle;
  final String statusText;
  final Color statusColor;
  final String time;

  const _HistoryCard({
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.statusText,
    required this.statusColor,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: iconColor,
            child: const Icon(Icons.menu_book, size: 18, color: Colors.black54),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        statusText,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      time,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.black38),
        ],
      ),
    );
  }
}

class _SuggestionTile extends StatelessWidget {
  final Color color;
  final String text;

  const _SuggestionTile({
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(8),
            ),

            child: const Icon(Icons.format_quote, size: 20),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '"$text"',
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
