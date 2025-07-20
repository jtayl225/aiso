import 'package:aiso/constants/app_colors.dart';
import 'package:aiso/models/recommendation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RecoCard extends StatelessWidget {
  final Recommendation reco;
  final VoidCallback? onTap;
  final VoidCallback? onMarkDone;

  const RecoCard({super.key, required this.reco, this.onTap, this.onMarkDone});

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('d MMM y').format(reco.createdAt);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      reco.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      reco.isDone
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: reco.isDone ? Colors.green : Colors.grey,
                    ),
                    onPressed: onMarkDone,
                  ),
                ],
              ),

              /// Description
              const SizedBox(height: 12),
              Text(
                reco.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),

              /// Optional Comment
              if (reco.generatedComment != null &&
                  reco.generatedComment!.isNotEmpty) ...[
                const SizedBox(height: 16),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        width: 4,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: AppColors.color1,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          reco.generatedComment!,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              /// Metadata row
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 4,
                children: [
                  // _Badge(label: "Category: ${reco.category}"),
                  // _Badge(label: "Cadence: ${reco.cadence}"),
                  _Badge(label: "Effort: ${reco.effort}"),
                  _Badge(label: "Reward: ${reco.reward}"),
                  // _Badge(label: "Created: $formattedDate"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
