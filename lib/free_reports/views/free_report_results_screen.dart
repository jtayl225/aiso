// // import 'dart:ui';
// // import 'package:aiso/Store/views/store_screen.dart';
// // import 'package:aiso/models/entity_model.dart';
// // import 'package:flutter/material.dart';

// // /// A screen that shows a free-ranking report for a given prompt.
// // /// Displays up to 10 Entity items in cards. If the entity's rank != searchTargetRank,
// // /// the card content is blurred and a "Reveal" button appears to initiate purchase.
// // class FreeReportResultScreen extends StatefulWidget {
// //   /// The prompt string, e.g. "Best real estate agent in Frankston, VIC Australia."
// //   final String prompt;

// //   /// List of up to 10 Entity objects to display
// //   final List<Entity> entities;

// //   /// The rank at which we want to show the entity without blur
// //   final int searchTargetRank;

// //   const FreeReportResultScreen({
// //     super.key,
// //     required this.prompt,
// //     required this.entities,
// //     required this.searchTargetRank,
// //   });

// //   @override
// //   State<FreeReportResultScreen> createState() => _FreeReportResultScreenState();
// // }

// // class _FreeReportResultScreenState extends State<FreeReportResultScreen> {
// //   /// Tracks which indexes have been revealed by successful purchase
// //   final Set<int> _revealed = {};

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Free Ranking Report'),
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             const Text(
// //               'Your free ranking report for:',
// //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //             ),
// //             const SizedBox(height: 8),
// //             Text(
// //               widget.prompt,
// //               style: const TextStyle(fontSize: 16),
// //             ),
// //             const SizedBox(height: 16),
// //             Expanded(
// //               child: ListView.builder(
// //                 itemCount: widget.entities.length.clamp(0, 10),
// //                 itemBuilder: (context, index) {
// //                   final entity = widget.entities[index];
// //                   final canShow =
// //                       entity.rank == widget.searchTargetRank ||
// //                       _revealed.contains(index);

// //                   return Padding(
// //                     padding: const EdgeInsets.only(bottom: 12.0),
// //                     child: Stack(
// //                       children: [
// //                         Card(
// //                           shape: RoundedRectangleBorder(
// //                             borderRadius: BorderRadius.circular(8),
// //                           ),
// //                           elevation: 2,
// //                           child: Padding(
// //                             padding: const EdgeInsets.all(12.0),
// //                             child: Column(
// //                               crossAxisAlignment: CrossAxisAlignment.start,
// //                               children: [
// //                                 Text(
// //                                   '${entity.rank}. ${entity.name}',
// //                                   style: const TextStyle(
// //                                     fontSize: 16,
// //                                     fontWeight: FontWeight.w600,
// //                                   ),
// //                                 ),
// //                                 const SizedBox(height: 6),
// //                                 Text(entity.description),
// //                                 if (entity.url != null) ...[
// //                                   const SizedBox(height: 6),
// //                                   Text(
// //                                     entity.url!,
// //                                     style: const TextStyle(
// //                                         color: Colors.blue,
// //                                         decoration: TextDecoration.underline),
// //                                   ),
// //                                 ],
// //                               ],
// //                             ),
// //                           ),
// //                         ),
// //                         // If not allowed to show, overlay blur + Reveal button
// //                         if (!canShow) ...[
// //                           // Blur overlay
// //                           Positioned.fill(
// //                             child: ClipRRect(
// //                               borderRadius: BorderRadius.circular(8),
// //                               child: BackdropFilter(
// //                                 filter: ImageFilter.blur(
// //                                     sigmaX: 5.0, sigmaY: 5.0),
// //                                 child: Container(
// //                                   color: Colors.black.withOpacity(0),
// //                                 ),
// //                               ),
// //                             ),
// //                           ),
// //                           // Reveal button triggers purchase
// //                           Positioned(
// //                             bottom: 8,
// //                             right: 8,
// //                             child: ElevatedButton(
// //                               onPressed: () async {
// //                                 // Navigate to Store screen and await purchase result
// //                                 final purchased = await Navigator.of(context).push<bool>(
// //                                   MaterialPageRoute(
// //                                     builder: (_) => const StoreScreen(),
// //                                   ),
// //                                 );
// //                                 // If purchase successful, mark revealed
// //                                 if (purchased == true) {
// //                                   setState(() {
// //                                     _revealed.add(index);
// //                                   });
// //                                 }
// //                               },
                              
// //                               style: ElevatedButton.styleFrom(
// //                                 shape: RoundedRectangleBorder(
// //                                   borderRadius: BorderRadius.circular(4),
// //                                 ),
// //                                 padding: const EdgeInsets.symmetric(
// //                                     horizontal: 12, vertical: 8),
// //                               ),
// //                               child: const Text('Reveal'),
// //                             ),
// //                           ),
// //                         ],
// //                       ],
// //                     ),
// //                   );
// //                 },
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'dart:ui';
// import 'package:aiso/free_reports/view_models/free_report_view_model.dart';
// // import 'package:aiso/models/entity_model.dart';
// import 'package:aiso/routing/route_names.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:aiso/routing/app_router.dart';

// class FreeReportResultScreen extends StatefulWidget {
//   const FreeReportResultScreen({super.key});

//   @override
//   State<FreeReportResultScreen> createState() => _FreeReportResultScreenState();
// }

// class _FreeReportResultScreenState extends State<FreeReportResultScreen> {
//   final Set<int> _revealed = {};

//   @override
//   Widget build(BuildContext context) {
//     final vm = context.watch<FreeReportViewModel>();
  
//     if (vm.entities.isEmpty || vm.promptText.isEmpty || vm.reportRunResults == null) {
//       debugPrint('DEBUG: Showing spinner...');
//       debugPrint('DEBUG: entities = ${vm.entities.length}');
//       debugPrint('DEBUG: promptText = "${vm.promptText}"');
//       debugPrint('DEBUG: reportRunResults = ${vm.reportRunResults}');
//       debugPrint('DEBUG: reportRunResults = ${vm.reportRunResults?.llmEpochId}');
//       return const Center(child: CircularProgressIndicator());
//     }

//     final entities = vm.entities;
//     final prompt = vm.promptText;
//     final searchTargetRank = vm.reportRunResults!.targetRank;

//     return Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Center(
//           child: ConstrainedBox(
//             constraints: const BoxConstraints(maxWidth: 600),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 const Text(
//                   'Your free report for:',
//                   style: TextStyle(fontSize: 16),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   prompt,
//                   style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   textAlign: TextAlign.center,
//                 ),

//                 const SizedBox(height: 16),

//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: entities.length.clamp(0, 10),
//                     itemBuilder: (context, index) {
//                       final entity = entities[index];
//                       final canShow =
//                           searchTargetRank != null &&
//                           (entity.rank == searchTargetRank ||
//                               _revealed.contains(index));
            
//                       return Padding(
//                         padding: const EdgeInsets.only(bottom: 12.0),
//                         child: Stack(
//                           children: [
//                             Card(
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               elevation: 2,
//                               child: Padding(
//                                 padding: const EdgeInsets.all(12.0),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       '${entity.rank}. ${entity.name}',
//                                       style: const TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 6),
//                                     Text(entity.description),
//                                     if (entity.url != null) ...[
//                                       const SizedBox(height: 6),
//                                       Text(
//                                         entity.url!,
//                                         style: const TextStyle(
//                                           color: Colors.blue,
//                                           decoration: TextDecoration.underline,
//                                         ),
//                                       ),
//                                     ],
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             if (!canShow) ...[
//                               Positioned.fill(
//                                 child: ClipRRect(
//                                   borderRadius: BorderRadius.circular(8),
//                                   child: BackdropFilter(
//                                     filter: ImageFilter.blur(
//                                         sigmaX: 5.0, sigmaY: 5.0),
//                                     child: Container(
//                                       color: Colors.black.withValues(alpha: 0),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Positioned(
//                                 bottom: 8,
//                                 right: 8,
//                                 child: ElevatedButton(
//                                   onPressed: () { // async

//                                     appRouter.go(storeRoute);

//                                     // debugPrint('navKey.currentState = ''${locator<NavigationService>().navigatorKey.currentState}');
//                                     // locator<NavigationService>().navigateTo(StoreRoute);

//                                     // final purchased = await Navigator.of(context).push<bool>(
//                                     //   MaterialPageRoute(
//                                     //     builder: (_) => const StoreScreen(),
//                                     //   ),
//                                     // );
//                                     // if (purchased == true) {
//                                     //   setState(() {
//                                     //     _revealed.add(index);
//                                     //   });
//                                     // }
//                                   },
//                                   style: ElevatedButton.styleFrom(
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(4),
//                                     ),
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 12, vertical: 8),
//                                   ),
//                                   child: const Text('View'),
//                                 ),
//                               ),
//                             ],
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//   }
// }
