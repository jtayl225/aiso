import 'package:aiso/models/prompt_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PromptCard extends StatelessWidget {
  final Prompt prompt;

  const PromptCard({super.key, required this.prompt});

  @override
  Widget build(BuildContext context) {
    final createdAtFormatted =
        DateFormat.yMMMd().add_jm().format(prompt.dbTimestamps.createdAt);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              prompt.prompt,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Created: $createdAtFormatted',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
