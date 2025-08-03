import 'package:aiso/Widgets/row_col.dart';
import 'package:aiso/constants/string_constants.dart';
import 'package:aiso/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ReportCard extends StatelessWidget {
  final IconData leadingIcon;
  final String title;
  final DateTime lastRunAt;
  final VoidCallback? onPressedRank;
  final VoidCallback? onPressedRecommendations;
  final VoidCallback? onTap;
  final DeviceScreenType deviceType;

  const ReportCard({
    super.key,
    required this.leadingIcon,
    required this.title,
    required this.lastRunAt,
    this.onPressedRank,
    this.onPressedRecommendations,
    this.onTap,
    required this.deviceType,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Icon(leadingIcon, size: 32),
            Image.asset(smallLogoImage, width: 20, height: 20),

            const SizedBox(width: 16),

            // Expanded(
            //   child: InkWell(
            //     onTap: onTap,
            //     borderRadius: BorderRadius.circular(12),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text(title, style: Theme.of(context).textTheme.titleMedium),
            //         const SizedBox(height: 4),
            //         Text(
            //           'Last run: ${_formatDate(lastRunAt)}',
            //           style: Theme.of(
            //             context,
            //           ).textTheme.bodySmall?.copyWith(color: Colors.grey),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    softWrap: false,
                  ),

                  if (deviceType != DeviceScreenType.desktop) const SizedBox(height: 4),

                  if (deviceType != DeviceScreenType.desktop)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ElevatedButton(
                          onPressed: onPressedRank,
                          child: Text(
                            'Rank',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(color: Colors.white),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: onPressedRecommendations,
                          child: Text(
                            // deviceType == DeviceScreenType.desktop
                            //     ? 'Recommendations'
                            //     : 'Recos',
                            'Recommendations',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(color: Colors.white),
                          ),
                        ),
                      ],
                    ),

                  const SizedBox(height: 4),

                  Text(
                    'Last run: ${_formatDate(lastRunAt)}',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: false,
                  ),

                  

                ],
              ),
            ),

            // Wrap(
            //   spacing: 8,
            //   runSpacing: 8,
            //   children: [
            //     ElevatedButton(
            //       onPressed: onPressedRank,
            //       child: const Text('Rank'),
            //     ),
            //     ElevatedButton(
            //       onPressed: onPressedRecommendations,
            //       child: const Text('Recommendations'),
            //     ),
            //   ],
            // ),
            // Spacer(),

            if (deviceType == DeviceScreenType.desktop)
              Wrap(
                spacing: 8,
                children: [
                  ElevatedButton(
                    onPressed: onPressedRank,
                    child: Text(
                      'Rank',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: onPressedRecommendations,
                    child: Text(
                      deviceType == DeviceScreenType.desktop
                          ? 'Recommendations'
                          : 'Recos',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),

            // Row(
            //   children: [

            //     ElevatedButton(
            //       onPressed: onPressedRank,
            //       child: Text('Rank', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white)),
            //     ),

            //       ElevatedButton(
            //         onPressed: onPressedRecommendations,
            //         child: Text('Recommendations', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white)),
            //       ),

            // ],
            // ),

            // Align(
            //   alignment: Alignment.centerRight, // <-- aligns to left inside the Expanded
            //   child: RowCol(
            //     layoutType: rowColType,
            //     colCrossAxisAlignment: CrossAxisAlignment.start, // in case it's Column
            //     rowCrossAxisAlignment: CrossAxisAlignment.end, // in case it's Column
            //     rowMainAxisAlignment: MainAxisAlignment.end,     // in case it's Row
            //     spacing: 8, // if your RowCol supports it
            //     children: [

            //       ConstrainedBox(
            //         constraints: BoxConstraints(minWidth: 100),
            //         child: ElevatedButton(
            //           onPressed: onPressedRank,
            //           child: Text('Rank', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white)),
            //         ),
            //       ),

            //       ElevatedButton(
            //         onPressed: onPressedRecommendations,
            //         child: Text('Recommendations', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white)),
            //       ),

            //     ]
            //   ),
            // ),

            // ElevatedButton(
            //   onPressed: onPressedRank,
            //   // onPressed: () => printDebug('Rank pressed'),
            //   child: const Text('Rank'),
            // ),

            // const SizedBox(width: 8),

            // ElevatedButton(
            //   onPressed: onPressedRecommendations,
            //   // onPressed: () => printDebug('Reco pressed'),
            //   child: const Text('Recommendations'),
            // ),

            // const Icon(Icons.arrow_forward_ios, size: 20),
          ],
        ),
      ),
    );
  }

  // String _formatDate(DateTime date) {
  //   return '${date.day}/${date.month}/${date.year}';
  // }

  String _formatDate(DateTime date) {
    return DateFormat('d MMMM y').format(date);
  }
}
