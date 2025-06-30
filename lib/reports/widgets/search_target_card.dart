import 'package:aiso/models/search_target_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SearchTargetCard extends StatelessWidget {
  final SearchTarget target;

  const SearchTargetCard({super.key, required this.target});

  @override
  Widget build(BuildContext context) {
    final createdAtFormatted =
        DateFormat.yMMMd().add_jm().format(target.dbTimestamps.createdAt);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              target.name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            if (target.industry != null)
              Text(
                'Industry: ${target.industry!.name}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            Text(
              'Type: ${target.entityType.name}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              target.description,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (target.url != null) ...[
              const SizedBox(height: 8),
              Text(
                'Website: ${target.url}',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.blue),
              ),
            ],
            const SizedBox(height: 12),
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
