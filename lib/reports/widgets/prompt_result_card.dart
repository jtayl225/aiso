import 'package:aiso/constants/app_colors.dart';
import 'package:aiso/reports/models/prompt_result_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PromptResultCard extends StatelessWidget {
  final PromptResult result;

  const PromptResultCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final createdAtFormatted =
        DateFormat.yMMMd().add_jm().format(result.dbTimestamps.createdAt);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: result.isTarget ? AppColors.color1 : Colors.transparent,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      // margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    result.entityName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                if (result.isTarget)
                  const Icon(Icons.flag, color: AppColors.color1),
              ],
            ),

            const SizedBox(height: 8),

            /// Description
            Text(
              result.entityDescription,
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            const SizedBox(height: 12),

            /// Metadata Chips
            Wrap(
              spacing: 10,
              runSpacing: 6,
              children: [
                _Badge(label: 'Rank: ${result.entityRank}'),
                // _Badge(label: 'Type: ${result.entityType}'),
                // _Badge(label: 'LLM: ${result.llmGeneration}'),
                // _Badge(label: 'Epoch: ${result.epoch}'),
                // _Badge(label: 'Created: $createdAtFormatted'),
              ],
            ),

            // /// Optional URL
            // if (result.entityUrl != null && result.entityUrl!.isNotEmpty) ...[
            //   const SizedBox(height: 12),
            //   TextButton(
            //     onPressed: () => _launchURL(result.entityUrl!),
            //     child: const Text('View Entity'),
            //   ),
            // ],
          ],
        ),
      ),
    );
  }

  void _launchURL(String url) {
    // Implement URL launcher logic (e.g., using `url_launcher` package)
    debugPrint('Open URL: $url');
  }
}

class _Badge extends StatelessWidget {
  final String label;

  const _Badge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label, style: const TextStyle(fontSize: 12)),
      backgroundColor: Colors.grey[200],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}
