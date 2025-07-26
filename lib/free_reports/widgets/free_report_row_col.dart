import 'dart:ui';
import 'package:aiso/free_reports/view_models/free_report_view_model.dart';
import 'package:aiso/routing/app_router.dart';
import 'package:aiso/routing/route_names.dart';
import 'package:aiso/themes/typography.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

class FreeReportRowCol extends StatelessWidget {

  final DeviceScreenType deviceType;
  
  const FreeReportRowCol({super.key, required this.deviceType});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<FreeReportViewModel>();

    if (vm.isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            vm.selectedPrompt?.prompt ?? 'Untitled Report',
            // style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            style: AppTextStyles.h1(deviceType),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 30.0),

          Text(
            vm.searchTargetRank != -1
                ? 'You are ranked #${vm.searchTargetRank}'
                : 'You are not in the top 10.',
            // style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            style: AppTextStyles.h2(deviceType),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 30.0),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: vm.entities.length.clamp(0, 10),
            itemBuilder: (context, index) {
              final entity = vm.entities[index];
              final canShow =
                  vm.searchTargetRank != -1 &&
                  (entity.rank == vm.searchTargetRank ||
                      vm.revealed.contains(index));
          
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Stack(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${entity.rank}. ${entity.name}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(entity.description),
                            if (entity.url != null) ...[
                              const SizedBox(height: 6),
                              Text(
                                entity.url!,
                                style: const TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    if (!canShow) ...[
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 5.0,
                              sigmaY: 5.0,
                            ),
                            child: Container(
                              color: Colors.black.withValues(alpha: 0),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: ElevatedButton(
                          onPressed: () {
                            // async
          
                            appRouter.go(storeRoute);
          
                            // debugPrint('navKey.currentState = ''${locator<NavigationService>().navigatorKey.currentState}');
                            // locator<NavigationService>().navigateTo(StoreRoute);
          
                            // final purchased = await Navigator.of(context).push<bool>(
                            //   MaterialPageRoute(
                            //     builder: (_) => const StoreScreen(),
                            //   ),
                            // );
                            // if (purchased == true) {
                            //   setState(() {
                            //     _revealed.add(index);
                            //   });
                            // }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                          child: const Text('Upgrade to view'),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
