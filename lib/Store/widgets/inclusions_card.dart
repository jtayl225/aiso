import 'package:flutter/material.dart';
import 'package:aiso/constants/app_colors.dart';
import 'package:aiso/Store/models/product_model.dart';

class InclusionsCard extends StatelessWidget {
  final List<ProductInclusion> inclusions;

  const InclusionsCard({
    super.key,
    required this.inclusions,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(
          color: AppColors.color1,
          width: 2,
        ),
      ),
      margin: const EdgeInsets.all(12),
      child: Column(
        children: [
          const SizedBox(height: 8),
          ...inclusions.map(
            (inclusion) => Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 4.0,
                horizontal: 16.0,
              ),
              child: Row(
                children: [
                  Icon(
                    inclusion.isIncluded
                        ? Icons.check_circle
                        : Icons.cancel,
                    color: inclusion.isIncluded ? Colors.green : Colors.red,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      inclusion.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.black,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
