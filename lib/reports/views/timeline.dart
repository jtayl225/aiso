// // // // import 'package:flutter/material.dart';

// // // // /// A simple model for each step in the timeline.
// // // // class StepData {
// // // //   final String title;
// // // //   final String description;

// // // //   StepData({required this.title, required this.description});
// // // // }

// // // // /// The Timeline widget: takes a list of steps and the index of the current step.
// // // // /// It displays each step as a row of [indicator + card], and colors the indicator
// // // // /// differently depending on stepIndex vs. currentStep.
// // // // class Timeline extends StatelessWidget {
// // // //   final List<StepData> steps;
// // // //   final int currentStep;
// // // //   final Color highlightColor;
// // // //   final Color defaultColor;

// // // //   /// [steps]: list of steps to show in order.
// // // //   /// [currentStep]: zero-based index of the “active” step.
// // // //   /// [highlightColor]: color for completed + active steps’ indicators.
// // // //   /// [defaultColor]: color for future steps’ indicators.
// // // //   const Timeline({
// // // //     super.key,
// // // //     required this.steps,
// // // //     required this.currentStep,
// // // //     this.highlightColor = Colors.blue,
// // // //     this.defaultColor = Colors.grey,
// // // //   });

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return ListView.builder(
// // // //       itemCount: steps.length,
// // // //       padding: const EdgeInsets.symmetric(vertical: 16),
// // // //       itemBuilder: (context, index) {
// // // //         final isFirst = index == 0;
// // // //         final isLast = index == steps.length - 1;
// // // //         final step = steps[index];

// // // //         // Decide colors for the top line, dot, and bottom line:
// // // //         // - If index < currentStep: “completed” (use highlightColor).
// // // //         // - If index == currentStep: “active” (use highlightColor).
// // // //         // - If index > currentStep: “upcoming” (use defaultColor).
// // // //         //
// // // //         // Top line: show if !isFirst. Color = (index <= currentStep) ? highlight : default
// // // //         // Bottom line: show if !isLast. Color = ((index + 1) <= currentStep) ? highlight : default
// // // //         final bool isCompleted = index < currentStep;
// // // //         final bool isActive = index == currentStep;

// // // //         final Color topLineColor =
// // // //             (!isFirst && index <= currentStep) ? highlightColor : defaultColor;
// // // //         final Color dotColor = (index <= currentStep)
// // // //             ? highlightColor
// // // //             : defaultColor; // completed or active get highlight
// // // //         final Color bottomLineColor = (!isLast && (index + 1) <= currentStep)
// // // //             ? highlightColor
// // // //             : defaultColor;

// // // //         return Padding(
// // // //           padding: const EdgeInsets.symmetric(vertical: 8.0),
// // // //           child: IntrinsicHeight(
// // // //             child: Row(
// // // //               crossAxisAlignment: CrossAxisAlignment.start,
// // // //               children: [
// // // //                 // Left side: the vertical line + dot + vertical line
// // // //                 SizedBox(
// // // //                   width: 32,
// // // //                   child: Column(
// // // //                     children: [
// // // //                       // Top segment
// // // //                       if (!isFirst)
// // // //                         Expanded(
// // // //                           child: Container(
// // // //                             width: 2,
// // // //                             color: topLineColor,
// // // //                           ),
// // // //                         )
// // // //                       else
// // // //                         const SizedBox(height: 8),
// // // //                       // Dot
// // // //                       Container(
// // // //                         width: 16,
// // // //                         height: 16,
// // // //                         decoration: BoxDecoration(
// // // //                           color: dotColor,
// // // //                           shape: BoxShape.circle,
// // // //                         ),
// // // //                       ),
// // // //                       // Bottom segment
// // // //                       if (!isLast)
// // // //                         Expanded(
// // // //                           child: Container(
// // // //                             width: 2,
// // // //                             color: bottomLineColor,
// // // //                           ),
// // // //                         )
// // // //                       else
// // // //                         const SizedBox(height: 8),
// // // //                     ],
// // // //                   ),
// // // //                 ),

// // // //                 const SizedBox(width: 12),

// // // //                 // Right side: the Card with title + description
// // // //                 Expanded(
// // // //                   child: Card(
// // // //                     elevation: isActive ? 4 : 1,
// // // //                     shape: RoundedRectangleBorder(
// // // //                       borderRadius: BorderRadius.circular(8),
// // // //                       side: BorderSide(
// // // //                         color: isActive ? highlightColor : Colors.transparent,
// // // //                         width: isActive ? 1.5 : 0,
// // // //                       ),
// // // //                     ),
// // // //                     child: Padding(
// // // //                       padding: const EdgeInsets.all(12.0),
// // // //                       child: Column(
// // // //                         crossAxisAlignment: CrossAxisAlignment.start,
// // // //                         children: [
// // // //                           Text(
// // // //                             step.title,
// // // //                             style: TextStyle(
// // // //                               fontSize: 16,
// // // //                               fontWeight:
// // // //                                   isActive ? FontWeight.bold : FontWeight.w600,
// // // //                               color: isActive ? highlightColor : Colors.black87,
// // // //                             ),
// // // //                           ),
// // // //                           const SizedBox(height: 6),
// // // //                           Text(
// // // //                             step.description,
// // // //                             style: TextStyle(
// // // //                               fontSize: 14,
// // // //                               color: Colors.black54,
// // // //                             ),
// // // //                           ),
// // // //                         ],
// // // //                       ),
// // // //                     ),
// // // //                   ),
// // // //                 ),
// // // //               ],
// // // //             ),
// // // //           ),
// // // //         );
// // // //       },
// // // //     );
// // // //   }
// // // // }


// // // import 'package:flutter/material.dart';

// // // /// A simple model for each step in the timeline.
// // // class StepData {
// // //   final String title;
// // //   final String description;

// // //   StepData({required this.title, required this.description});
// // // }

// // // /// The Timeline widget: takes a list of steps and the index of the current step.
// // // /// It displays each step as a row of [indicator + card], and colors the indicator
// // // /// differently depending on whether it’s completed, active, or upcoming.
// // // /// This version guarantees the dot is vertically centered, and hides
// // // /// the top‐line on the first step and bottom‐line on the last step.
// // // class Timeline extends StatelessWidget {
// // //   final List<StepData> steps;
// // //   final int currentStep;
// // //   final Color highlightColor;
// // //   final Color defaultColor;

// // //   /// [steps]: list of steps to show in order.
// // //   /// [currentStep]: zero‐based index of the “active” step.
// // //   /// [highlightColor]: color for completed + active steps’ indicators.
// // //   /// [defaultColor]: color for future steps’ indicators.
// // //   const Timeline({
// // //     super.key,
// // //     required this.steps,
// // //     required this.currentStep,
// // //     this.highlightColor = Colors.blue,
// // //     this.defaultColor = Colors.grey,
// // //   });

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return ListView.builder(
// // //       itemCount: steps.length,
// // //       padding: const EdgeInsets.symmetric(vertical: 16),
// // //       itemBuilder: (context, index) {
// // //         final isFirst = index == 0;
// // //         final isLast = index == steps.length - 1;

// // //         // Determine colors for each segment:
// // //         // • Top segment: transparent if first; otherwise highlight/default.
// // //         // • Dot: highlight if index <= currentStep, else default.
// // //         // • Bottom segment: transparent if last; otherwise highlight/default.
// // //         final bool isActive = index == currentStep;
// // //         final bool isCompleted = index < currentStep;

// // //         final Color topLineColor = isFirst
// // //             ? Colors.transparent
// // //             : (index <= currentStep ? highlightColor : defaultColor);

// // //         final Color dotColor = (index <= currentStep)
// // //             ? highlightColor
// // //             : defaultColor;

// // //         final Color bottomLineColor = isLast
// // //             ? Colors.transparent
// // //             : ((index + 1) <= currentStep ? highlightColor : defaultColor);

// // //         final step = steps[index];

// // //         return Padding(
// // //           padding: const EdgeInsets.symmetric(vertical: 8.0),
// // //           child: IntrinsicHeight(
// // //             child: Row(
// // //               // Center the column so the dot is in the vertical center of the row
// // //               crossAxisAlignment: CrossAxisAlignment.center,
// // //               children: [
// // //                 // ┌──────────────────────────────┐
// // //                 // │    Left: indicator column    │
// // //                 // │  (top line, dot, bottom line)│
// // //                 // └──────────────────────────────┘
// // //                 SizedBox(
// // //                   width: 32,
// // //                   child: Column(
// // //                     children: [
// // //                       // Top segment: always Expanded so it takes half the space above the dot.
// // //                       Expanded(
// // //                         child: Container(
// // //                           width: 2,
// // //                           color: topLineColor,
// // //                         ),
// // //                       ),

// // //                       // The dot itself
// // //                       Container(
// // //                         width: 16,
// // //                         height: 16,
// // //                         decoration: BoxDecoration(
// // //                           color: dotColor,
// // //                           shape: BoxShape.circle,
// // //                         ),
// // //                       ),

// // //                       // Bottom segment: always Expanded so it takes half the space below the dot.
// // //                       Expanded(
// // //                         child: Container(
// // //                           width: 2,
// // //                           color: bottomLineColor,
// // //                         ),
// // //                       ),
// // //                     ],
// // //                   ),
// // //                 ),

// // //                 const SizedBox(width: 12),

// // //                 // ┌──────────────────────────────────────┐
// // //                 // │ Right: the Card with title/description │
// // //                 // └──────────────────────────────────────┘
// // //                 Expanded(
// // //                   child: Card(
// // //                     elevation: isActive ? 4 : 1,
// // //                     shape: RoundedRectangleBorder(
// // //                       borderRadius: BorderRadius.circular(8),
// // //                       side: BorderSide(
// // //                         color: isActive ? highlightColor : Colors.transparent,
// // //                         width: isActive ? 1.5 : 0,
// // //                       ),
// // //                     ),
// // //                     child: Padding(
// // //                       padding: const EdgeInsets.all(12.0),
// // //                       child: Column(
// // //                         crossAxisAlignment: CrossAxisAlignment.start,
// // //                         children: [
// // //                           Text(
// // //                             step.title,
// // //                             style: TextStyle(
// // //                               fontSize: 16,
// // //                               fontWeight:
// // //                                   isActive ? FontWeight.bold : FontWeight.w600,
// // //                               color:
// // //                                   isActive ? highlightColor : Colors.black87,
// // //                             ),
// // //                           ),
// // //                           const SizedBox(height: 6),
// // //                           Text(
// // //                             step.description,
// // //                             style: const TextStyle(
// // //                               fontSize: 14,
// // //                               color: Colors.black54,
// // //                             ),
// // //                           ),
// // //                         ],
// // //                       ),
// // //                     ),
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //         );
// // //       },
// // //     );
// // //   }
// // // }


// // import 'package:flutter/material.dart';

// // /// A simple model for each step in the timeline.
// // class StepData {
// //   final String title;
// //   final String description;

// //   StepData({required this.title, required this.description});
// // }

// // /// The Timeline widget: takes a list of steps and the index of the current step.
// // /// It displays each step as a row of [indicator + card], and colors the indicator
// // /// differently depending on whether it’s completed, active, or upcoming.
// // /// This version puts a check (“tick”) inside the circle when the step is fully completed.
// // class Timeline extends StatelessWidget {
// //   final List<StepData> steps;
// //   final int currentStep;
// //   final Color highlightColor;
// //   final Color defaultColor;

// //   /// [steps]: list of steps to show in order.
// //   /// [currentStep]: zero‐based index of the “active” step.
// //   /// [highlightColor]: color for completed + active steps’ indicators.
// //   /// [defaultColor]: color for future steps’ indicators.
// //   const Timeline({
// //     super.key,
// //     required this.steps,
// //     required this.currentStep,
// //     this.highlightColor = Colors.blue,
// //     this.defaultColor = Colors.grey,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return ListView.builder(
// //       itemCount: steps.length,
// //       padding: const EdgeInsets.symmetric(vertical: 16),
// //       itemBuilder: (context, index) {
// //         final isFirst = index == 0;
// //         final isLast = index == steps.length - 1;

// //         // Determine if this step is completed (< current), active (== current), or upcoming (> current)
// //         final bool isCompleted = index < currentStep;
// //         final bool isActive = index == currentStep;

// //         // Top line: transparent if first; otherwise highlight or default
// //         final Color topLineColor = isFirst
// //             ? Colors.transparent
// //             : (index <= currentStep ? highlightColor : defaultColor);

// //         // Dot: highlight if index <= currentStep; default otherwise.
// //         // But if isCompleted, we’ll draw a check inside.
// //         final Color dotColor = (index <= currentStep)
// //             ? highlightColor
// //             : defaultColor;

// //         // Bottom line: transparent if last; otherwise highlight or default
// //         final Color bottomLineColor = isLast
// //             ? Colors.transparent
// //             : ((index + 1) <= currentStep
// //                 ? highlightColor
// //                 : defaultColor);

// //         final step = steps[index];

// //         return Padding(
// //           padding: const EdgeInsets.symmetric(vertical: 8.0),
// //           child: IntrinsicHeight(
// //             child: Row(
// //               crossAxisAlignment: CrossAxisAlignment.center,
// //               children: [
// //                 // ┌───────────────────────────────┐
// //                 // │ Left: indicator column         │
// //                 // │ (top line, dot [+ tick], bottom line) │
// //                 // └───────────────────────────────┘
// //                 SizedBox(
// //                   width: 32,
// //                   child: Column(
// //                     children: [
// //                       // Top segment (always Expanded, even if transparent)
// //                       Expanded(
// //                         child: Container(
// //                           width: 2,
// //                           color: topLineColor,
// //                         ),
// //                       ),

// //                       // Dot (circle). If completed, draw a check inside:
// //                       Container(
// //                         width: 16,
// //                         height: 16,
// //                         decoration: BoxDecoration(
// //                           color: dotColor,
// //                           shape: BoxShape.circle,
// //                         ),
// //                         child: isCompleted
// //                             ? const Center(
// //                                 child: Icon(
// //                                   Icons.check,
// //                                   size: 12,
// //                                   color: Colors.white,
// //                                 ),
// //                               )
// //                             : null,
// //                       ),

// //                       // Bottom segment (always Expanded, even if transparent)
// //                       Expanded(
// //                         child: Container(
// //                           width: 2,
// //                           color: bottomLineColor,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),

// //                 const SizedBox(width: 12),

// //                 // ┌───────────────────────────────────────┐
// //                 // │ Right: the Card with title / description │
// //                 // └───────────────────────────────────────┘
// //                 Expanded(
// //                   child: Card(
// //                     elevation: isActive ? 4 : 1,
// //                     shape: RoundedRectangleBorder(
// //                       borderRadius: BorderRadius.circular(8),
// //                       side: BorderSide(
// //                         color: isActive ? highlightColor : Colors.transparent,
// //                         width: isActive ? 1.5 : 0,
// //                       ),
// //                     ),
// //                     child: Padding(
// //                       padding: const EdgeInsets.all(12.0),
// //                       child: Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           Text(
// //                             step.title,
// //                             style: TextStyle(
// //                               fontSize: 16,
// //                               fontWeight:
// //                                   isActive ? FontWeight.bold : FontWeight.w600,
// //                               color:
// //                                   isActive ? highlightColor : Colors.black87,
// //                             ),
// //                           ),
// //                           const SizedBox(height: 6),
// //                           Text(
// //                             step.description,
// //                             style: const TextStyle(
// //                               fontSize: 14,
// //                               color: Colors.black54,
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         );
// //       },
// //     );
// //   }
// // }


import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart'; // 1) import flutter_markdown
import 'package:markdown/markdown.dart' as md;

/// A simple model for each step in the timeline.
class StepData {
  final String title;
  final String description;

  StepData({required this.title, required this.description});
}

/// The Timeline widget: takes a list of steps and the index of the current step.
/// It displays each step as a row of [indicator + card], and colors the indicator
/// differently depending on whether it’s completed, active, or upcoming. 
/// This version puts a check when completed, and renders markdown in the description.
class Timeline extends StatelessWidget {
  final List<StepData> steps;
  final int currentStep;
  final Color highlightColor;
  final Color defaultColor;

  /// [steps]: list of steps to show in order.
  /// [currentStep]: zero‐based index of the “active” step.
  /// [highlightColor]: color for completed + active steps’ indicators.
  /// [defaultColor]: color for future steps’ indicators.
  const Timeline({
    super.key,
    required this.steps,
    required this.currentStep,
    this.highlightColor = Colors.blue,
    this.defaultColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: steps.length,
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemBuilder: (context, index) {
        final isFirst = index == 0;
        final isLast = index == steps.length - 1;

        // Determine if this step is completed (< current), active (== current), or upcoming (> current)
        final bool isCompleted = index < currentStep;
        final bool isActive = index == currentStep;

        // Top line: transparent if first; otherwise highlight or default
        final Color topLineColor = isFirst
            ? Colors.transparent
            : (index <= currentStep ? highlightColor : defaultColor);

        // Dot: highlight if index <= currentStep; default otherwise.
        // But if isCompleted, we’ll draw a check inside.
        final Color dotColor = (index <= currentStep)
            ? highlightColor
            : defaultColor;

        // Bottom line: transparent if last; otherwise highlight or default
        final Color bottomLineColor = isLast
            ? Colors.transparent
            : ((index + 1) <= currentStep
                ? highlightColor
                : defaultColor);

        final step = steps[index];

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ┌───────────────────────────────┐
                // │ Left: indicator column         │
                // │ (top line, dot [+ tick], bottom line) │
                // └───────────────────────────────┘
                SizedBox(
                  width: 32,
                  child: Column(
                    children: [
                      // Top segment (always Expanded, even if transparent)
                      Expanded(
                        child: Container(
                          width: 2,
                          color: topLineColor,
                        ),
                      ),

                      // Dot (circle). If completed, draw a check inside:
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: dotColor,
                          shape: BoxShape.circle,
                        ),
                        child: isCompleted
                            ? const Center(
                                child: Icon(
                                  Icons.check,
                                  size: 12,
                                  color: Colors.white,
                                ),
                              )
                            : null,
                      ),

                      // Bottom segment (always Expanded, even if transparent)
                      Expanded(
                        child: Container(
                          width: 2,
                          color: bottomLineColor,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // ┌───────────────────────────────────────┐
                // │ Right: the Card with title / markdown description │
                // └───────────────────────────────────────┘
                Expanded(
                  child: Card(
                    elevation: isActive ? 4 : 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: isActive ? highlightColor : Colors.transparent,
                        width: isActive ? 1.5 : 0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            step.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight:
                                  isActive ? FontWeight.bold : FontWeight.w600,
                              color:
                                  isActive ? highlightColor : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 6),

                          // ← Replace plain Text(...) with MarkdownBody(...)
                          MarkdownBody(
                              data: step.description,
                              extensionSet: md.ExtensionSet.gitHubWeb,
                              styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                                .copyWith(p: const TextStyle(fontSize: 14, color: Colors.black54)),
                            ),         

                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter_markdown/flutter_markdown.dart';
// import 'package:markdown/markdown.dart' as md;

// /// A simple model for each step in the timeline.
// class StepData {
//   final String title;
//   final String description;

//   StepData({required this.title, required this.description});
// }

// /// The Timeline widget: takes a list of steps and the index of the current step.
// /// It displays each step as a row of [indicator + card], and colors the indicator
// /// differently depending on whether it’s completed, active, or upcoming.
// /// This version centers the dot by using `Row(crossAxisAlignment: CrossAxisAlignment.center)`
// /// instead of `IntrinsicHeight`.
// class Timeline extends StatelessWidget {
//   final List<StepData> steps;
//   final int currentStep;
//   final Color highlightColor;
//   final Color defaultColor;

//   const Timeline({
//     super.key,
//     required this.steps,
//     required this.currentStep,
//     this.highlightColor = Colors.blue,
//     this.defaultColor = Colors.grey,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: steps.length,
//       padding: const EdgeInsets.symmetric(vertical: 16),
//       itemBuilder: (context, index) {
//         final isFirst = index == 0;
//         final isLast = index == steps.length - 1;

//         // Determine if this step is completed (< current), active (== current), or upcoming (> current)
//         final bool isCompleted = index < currentStep;
//         final bool isActive = index == currentStep;

//         // Top line: transparent if first; otherwise highlight or default
//         final Color topLineColor = isFirst
//             ? Colors.transparent
//             : (index <= currentStep ? highlightColor : defaultColor);

//         // Dot: highlight if index <= currentStep; default otherwise.
//         // If isCompleted, we’ll draw a check inside.
//         final Color dotColor = (index <= currentStep)
//             ? highlightColor
//             : defaultColor;

//         // Bottom line: transparent if last; otherwise highlight or default
//         final Color bottomLineColor = isLast
//             ? Colors.transparent
//             : ((index + 1) <= currentStep
//                 ? highlightColor
//                 : defaultColor);

//         final step = steps[index];

//         return Padding(
//           padding: const EdgeInsets.symmetric(vertical: 8.0),
//           child: Row(
//             // By centering the Row, its height becomes the height of the tallest child (the card).
//             // The left Column’s two Expanded containers will then each fill half of that height,
//             // placing the dot exactly in the middle.
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               // ┌───────────────────────────────┐
//               // │ Left: indicator column         │
//               // │ (top line, dot [+ tick], bottom line) │
//               // └───────────────────────────────┘
//               SizedBox(
//                 width: 32,
//                 child: Column(
//                   children: [
//                     // Top segment (always Expanded; paint transparent if first)
//                     Expanded(
//                       child: Container(
//                         width: 2,
//                         color: topLineColor,
//                       ),
//                     ),

//                     // Dot (circle). If completed, draw a check inside:
//                     Container(
//                       width: 16,
//                       height: 16,
//                       decoration: BoxDecoration(
//                         color: dotColor,
//                         shape: BoxShape.circle,
//                       ),
//                       child: isCompleted
//                           ? const Center(
//                               child: Icon(
//                                 Icons.check,
//                                 size: 12,
//                                 color: Colors.white,
//                               ),
//                             )
//                           : null,
//                     ),

//                     // Bottom segment (always Expanded; paint transparent if last)
//                     Expanded(
//                       child: Container(
//                         width: 2,
//                         color: bottomLineColor,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(width: 12),

//               // ┌───────────────────────────────────────┐
//               // │ Right: the Card with title / markdown description │
//               // └───────────────────────────────────────┘
//               Expanded(
//                 child: Card(
//                   elevation: isActive ? 4 : 1,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                     side: BorderSide(
//                       color: isActive ? highlightColor : Colors.transparent,
//                       width: isActive ? 1.5 : 0,
//                     ),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(12.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           step.title,
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight:
//                                 isActive ? FontWeight.bold : FontWeight.w600,
//                             color: isActive ? highlightColor : Colors.black87,
//                           ),
//                         ),
//                         const SizedBox(height: 6),

//                         // Replace plain Text with Markdown to render GitHub-flavored Markdown.
//                         // ← Use MarkdownBody instead of Markdown
//                         MarkdownBody(
//                           data: step.description,
//                           extensionSet: md.ExtensionSet.gitHubWeb,
//                           styleSheet: MarkdownStyleSheet.fromTheme(
//                             Theme.of(context),
//                           ).copyWith(
//                             p: const TextStyle(
//                               fontSize: 14,
//                               color: Colors.black54,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

