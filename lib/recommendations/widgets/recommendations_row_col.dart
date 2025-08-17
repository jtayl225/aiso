import 'package:aiso/models/location_models.dart';
import 'package:aiso/recommendations/view_models/recommendation_v2_view_model.dart';
import 'package:aiso/reports/widgets/recommendation_card.dart';
import 'package:aiso/reports/widgets/upgrade_prompt_card.dart';
import 'package:aiso/routing/app_router.dart';
import 'package:aiso/routing/route_names.dart';
import 'package:aiso/themes/typography.dart';
import 'package:aiso/view_models/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'dart:math' as math;

class RecommendationsRowCol extends StatefulWidget {
  final DeviceScreenType deviceType;

  const RecommendationsRowCol({
    super.key,
    required this.deviceType,
  });

  @override
  State<RecommendationsRowCol> createState() => _RecommendationsRowColState();
}

class _RecommendationsRowColState extends State<RecommendationsRowCol> {
  bool _showMore = false;
  static const int _initialCount = 3;

  @override
  Widget build(BuildContext context) {

    final authVm = context.watch<AuthViewModel>();
    final vm = context.watch<RecommendationV2ViewModel>();

    final bool canShow = (authVm.isSubscribed == true);
    final total = vm.sortedRecommendations.length;
    final shown = math.min(_initialCount, total);

    if (vm.isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (vm.sortedRecommendations.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text(
            'Your recommendations are still processing and will be ready soon. Please try again in a few minutes (up to 10 minutes).',
          ),
        ),
      );
    }

    // Decide how many to show based on _showMore
    final recosToShow = _showMore
        ? vm.sortedRecommendations
        : vm.sortedRecommendations.take(_initialCount).toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Recommendations to improve your AI visibility',
            style: AppTextStyles.h1(widget.deviceType).copyWith(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 40.0),

           DropdownButtonFormField<Locality>(
              isExpanded: true,
              value: vm.selectedLocation,
              decoration: const InputDecoration(
                labelText: 'Locations',
                border: OutlineInputBorder(),
              ),
              items: [
            
                ...vm.locations.map((l) {
                  return DropdownMenuItem<Locality>(
                    value: l,
                    child: Text(l.name, overflow: TextOverflow.ellipsis),
                  );
                }),

                DropdownMenuItem<Locality>(value: null, child: Text('All')),

              ],
            
              onChanged: (value) {
                vm.selectedLocation = value;
              },
            ),

          const SizedBox(height: 40.0),

          Text(
            'Top $shown recommendation${shown == 1 ? '' : 's'} ($shown of $total)',
            style: AppTextStyles.h2(widget.deviceType).copyWith(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 40.0),

          // Recommendations list (paid/subscribed only)
          if (canShow && vm.sortedRecommendations.isNotEmpty) ...[
            ...recosToShow.map(
              (reco) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: RecoCard(
                  reco: reco,
                  onTap: () => debugPrint('DEBUG'),
                  onMarkDone: () => vm.toggleRecommendationDone(recommendationId: reco.id),
                  deviceType: widget.deviceType,
                ),
              ),
            ),

            // Show More / Show Less button (only if there are more than _initialCount)
            if (vm.sortedRecommendations.length > _initialCount) ...[
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => setState(() => _showMore = !_showMore),
                child: Text(_showMore ? 'Show less' : 'Show more'),
              ),
            ],
          ],

          // Upgrade prompt if user can’t see recommendations
          if (!canShow)
            UpgradePromptCard(onSubscribe: () => appRouter.go(storeRoute)),

          const SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
