// import 'package:aiso/models/report_model.dart';
// import 'package:aiso/models/report_results.dart';
// import 'package:aiso/models/search_target_type_enum.dart';
// import 'package:aiso/view_models/report_results_view_model.dart';
// import 'package:aiso/view_models/reports_view_model.dart';
// import 'package:aiso/views/reports/reports_editor_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class ReportResultsScreen extends StatefulWidget {
//   final String reportId;
//   const ReportResultsScreen({super.key, required this.reportId});

//   @override
//   State<ReportResultsScreen> createState() => _ReportResultsScreenState();
// }

// class _ReportResultsScreenState extends State<ReportResultsScreen> {

//   int? _sortColumnIndex;
//   bool _sortAscending = true;

//   // @override
//   // void initState() {
//   //   super.initState();
//   //   // Trigger data fetch for the report using the ViewModel
//   //   // final reportViewModel = context.read<ReportViewModel>();
//   //   // reportViewModel.fetchReportResults(widget.reportId);
//   // }

//   void _sort<T>(
//     // Report report,
//     List<ReportResult> results,
//     Comparable<T> Function(ReportResult d) getField,
//     int columnIndex,
//     bool ascending,
//   ) {
//     // if (results == null) return;

//     setState(() {
//       _sortColumnIndex = columnIndex;
//       _sortAscending = ascending;

//       results.sort((a, b) {
//         final aValue = getField(a);
//         final bValue = getField(b);
//         final cmp = Comparable.compare(aValue, bValue);
//         return ascending ? cmp : -cmp;
//       });
//     });
//   }

  
//   @override
//   Widget build(BuildContext context) {
//     final resultsViewModel = Provider.of<ReportResultsViewModel>(context);
//     final reportViewModel = Provider.of<ReportViewModel>(context);
//     final results = resultsViewModel.results;
//     final searchTarget = resultsViewModel.searchTarget;
//     final report = reportViewModel.getReportById(widget.reportId);

//     return Consumer<ReportViewModel>(
//       builder: (context, viewModel, child) {
//         // final report = viewModel.getReportById(widget.reportId);

//         // if (viewModel.isLoading) {
//         //   return const Center(child: CircularProgressIndicator());
//         // }

//         if (report == null) {
//           return const Center(child: Text('Report not found'));
//         }

//         // final results = resultsViewModel.results;
//         // final searchTarget = resultsViewModel.searchTarget;

//         return Scaffold(
//           appBar: AppBar(
//             title: Text(report.title),
//             actions: [
//               IconButton(
//                 icon: const Icon(Icons.edit),
//                 tooltip: 'Edit Report',
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => ReportEditorScreen(report: report),
//                     ),
//                   );
//                 },
//               )
//             ],
//           ),
//           body: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     ElevatedButton(
//                       onPressed: () async {
//                         await resultsViewModel.runReport(report.id);
//                       },
//                       child: const Text('Run Report'),
//                     ),
//                     const SizedBox(width: 16),
//                     if (resultsViewModel.isLoading) ...[
//                       const SizedBox(
//                         width: 16,
//                         height: 16,
//                         child: CircularProgressIndicator(strokeWidth: 2),
//                       ),
//                       const SizedBox(width: 8),
//                       const Text('Loading...')
//                     ],
//                   ],
//                 ),

//                 const SizedBox(height: 16),

//                 // SEARCH TARGET (Read-only)
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Search Target',
//                       style: Theme.of(context).textTheme.titleMedium,
//                     ),
//                     const SizedBox(height: 8),

//                     Text(
//                       'Type: ${searchTarget?.type.label}',
//                       style: Theme.of(context).textTheme.bodyMedium,
//                     ),
//                     const SizedBox(height: 8),

//                     Text(
//                       'Name: ${searchTarget?.name}',
//                       style: Theme.of(context).textTheme.bodyMedium,
//                     ),
//                     const SizedBox(height: 8),

//                     Text(
//                       'Description: ${searchTarget?.description}',
//                       style: Theme.of(context).textTheme.bodyMedium,
//                     ),
//                     const SizedBox(height: 8),

//                     if (searchTarget?.url != null)
//                       Text(
//                         'URL: ${searchTarget?.url}',
//                         style: Theme.of(context).textTheme.bodyMedium,
//                       ),
//                     const SizedBox(height: 16),

//                   ],
//                 ),

//                 const SizedBox(height: 16),

//                 Expanded(
//                   child: SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: DataTable(
//                       sortColumnIndex: _sortColumnIndex,
//                       sortAscending: _sortAscending,
//                       columns: [
//                         DataColumn(
//                           label: Text('Prompt'),
//                           numeric: false,
//                           onSort: (columnIndex, ascending) => _sort(results, (d) => d.prompt, columnIndex, ascending),
//                           ),
//                         DataColumn(
//                           label: Text('LLM'),
//                           numeric: false,
//                           onSort: (columnIndex, ascending) => _sort(results, (d) => d.llm.name, columnIndex, ascending),
//                           ),
//                         DataColumn(
//                           label: Text('Alpha'),
//                           numeric: true,
//                           onSort: (columnIndex, ascending) => _sort(results, (d) => d.alpha, columnIndex, ascending),
//                           ),
//                         DataColumn(
//                           label: Text('N'),
//                           numeric: true,
//                           onSort: (columnIndex, ascending) => _sort(results, (d) => d.n, columnIndex, ascending),
//                           ),
//                         DataColumn(
//                           label: Text('%'),
//                           numeric: true,
//                           onSort: (columnIndex, ascending) => _sort(results, (d) => d.pct, columnIndex, ascending),
//                           ),
//                       ],
//                       rows: results.map((result) {
//                         return DataRow(
//                           cells: [
//                             DataCell(Text(result.prompt)),
//                             DataCell(Text(result.llm.name)), // Enum name as string
//                             DataCell(Text(result.alpha.toString())),
//                             DataCell(Text(result.n.toString())),
//                             DataCell(Text(result.pctString)),
//                           ],
//                         );
//                       }).toList(),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );

//       },
//     );
//   }
// }



import 'package:aiso/constants/app_colors.dart';
import 'package:aiso/constants/string_constants.dart';
import 'package:aiso/models/purchase_enum.dart';
import 'package:aiso/reports/models/report_model.dart';
import 'package:aiso/models/search_target_type_enum.dart';
import 'package:aiso/models/report_results.dart';
import 'package:aiso/view_models/auth_view_model.dart';
import 'package:aiso/reports/view_models/report_results_view_model.dart';
import 'package:aiso/reports/view_models/reports_view_model.dart';
import 'package:aiso/views/plots/BlurredOverlay.dart';
import 'package:aiso/views/plots/ProportionCircle.dart';
import 'package:aiso/reports/views/line_chart.dart';
import 'package:aiso/reports/views/prompt_result_screen.dart';
import 'package:aiso/reports/views/reports_editor_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class LLMData {
  final String name;
  final String logo;
  final double accuracy;
  final double rank;
  final bool isBlurred;

  LLMData({
    required this.name,
    required this.logo,
    required this.accuracy,
    required this.rank,
    required this.isBlurred,
  });
}


class ReportResultsScreen extends StatefulWidget {
  final String reportId;
  
  const ReportResultsScreen({super.key, required this.reportId});

  @override
  State<ReportResultsScreen> createState() => _ReportResultsScreenState();
}

class _ReportResultsScreenState extends State<ReportResultsScreen> {
  int? _sortColumnIndex;
  bool _sortAscending = true;

  void _sort<T>(
    List<ReportResult> results,
    Comparable<T> Function(ReportResult d) getField,
    int columnIndex,
    bool ascending,
  ) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
      results.sort((a, b) {
        final aValue = getField(a);
        final bValue = getField(b);
        return ascending ? Comparable.compare(aValue, bValue) : Comparable.compare(bValue, aValue);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();
    final reportViewModel = context.watch<ReportsViewModel>();
    final resultsViewModel = context.watch<ReportResultsViewModel>();

    final Report? report = reportViewModel.getReportById(widget.reportId);
    final results = resultsViewModel.results;
    final searchTarget = resultsViewModel.searchTarget;
    final isSubscribed = authViewModel.isSubscribed;

    final llms = [
      LLMData(
        name: "chatGPT",
        logo: "assets/OpenAI-black-monoblossom.png",
        accuracy: 0.85,
        rank: 3.7,
        isBlurred: false,
      ),
      LLMData(
        name: "Gemini",
        logo: "assets/gemini_icon.png",
        accuracy: 0.72,
        rank: 4.1,
        isBlurred: true,
      ),
    ];


    if (report == null) {
      return const Scaffold(
        body: Center(child: Text('Report not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(report.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit Report',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ReportEditorScreen(report: report),
                ),
              );
            },
          ),
        ],
      ),
      body: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(overscroll: false),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                _buildActionButtons(context, resultsViewModel, report.id),

                const SizedBox(height: 24),

                _buildSearchTargetInfo(context, searchTarget),

                const SizedBox(height: 24),
        
        
                Text('Summary', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                // Text("Plots"),
        
                Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Label Column
                        SizedBox(
                          height: 278,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              SizedBox(height: 84),
                              Text('% Top 10'),
                              Spacer(),
                              Text('Average Rank'),
                              SizedBox(height: 50),
                            ],
                          ),
                        ),
                    
                        const SizedBox(width: 16), // space between label and cards
                    
                        _llmPerformanceCard(
                          logoImage: "assets/OpenAI-black-monoblossom.png",
                          llmName: "chatGPT",
                          accuracy: 0.85,
                          rank: 3.7,
                          isBlurred: false,
                        ),
                        _llmPerformanceCard(
                          logoImage: "assets/gemini_icon.png",
                          llmName: "Gemini",
                          accuracy: 0.72,
                          rank: 4.1,
                          isBlurred: !isSubscribed,
                        ),
                         _llmPerformanceCard(
                          logoImage: "assets/gemini_icon.png",
                          llmName: "Gemini",
                          accuracy: 0.72,
                          rank: 4.1,
                          isBlurred: !isSubscribed,
                        ),
                         _llmPerformanceCard(
                          logoImage: "assets/gemini_icon.png",
                          llmName: "Gemini",
                          accuracy: 0.72,
                          rank: 4.1,
                          isBlurred: !isSubscribed,
                        ),
                         _llmPerformanceCard(
                          logoImage: "assets/gemini_icon.png",
                          llmName: "Gemini",
                          accuracy: 0.72,
                          rank: 4.1,
                          isBlurred: !isSubscribed,
                        ),
                      ],
                    ),
                  ),
                ),
        
        
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: [
                //     Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         Image.asset(
                //         logoImage,
                //         width: 30.0,
                //         height: 30.0,
                //       ),
                //         const SizedBox(width: 4),
                //         Text("chatGPT"),
                //       ],
                //     ),
                    
                //     const SizedBox(height: 4),
                    
                //     BlurredOverlay(
                //       isBlurred: false,
                //       child: CustomPaint(
                //         painter: RadialPainter(proportion: 0.85, backgroundColor: AppColors.color3),
                //         child: Center(
                //           child: Text("85%"),
                //         ),
                //       ),
                //     ),
                    
                //     const SizedBox(height: 4),
                    
                //     BlurredOverlay(
                //       isBlurred: false,
                //       child: CustomPaint(
                //         painter: RadialPainter(proportion: ((10+1) - 3.7) / 10, backgroundColor: AppColors.color3),
                //         child: Center(
                //           child: Text("#3.7"),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
        
        
        
        
          
                // Center(
                //   child: SingleChildScrollView(
                //     scrollDirection: Axis.horizontal,
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         Padding(
                //           padding: const EdgeInsets.all(16.0),
                //           child: ConstrainedBox(
                //             constraints: BoxConstraints(
                //               maxWidth: 300,  // maximum width
                //               maxHeight: 300, // maximum height
                //             ),
                //             child: AspectRatio(
                //               aspectRatio: 1.5,
                //               child: DateLineChart(),
                //             ),
                //           ),              
                //         ),
        
                //         const SizedBox(height: 8),
        
                //         Padding(
                //           padding: const EdgeInsets.all(16.0),
                //           child: ConstrainedBox(
                //             constraints: BoxConstraints(
                //               maxWidth: 300,  // maximum width
                //               maxHeight: 300, // maximum height
                //             ),
                //             child: AspectRatio(
                //               aspectRatio: 1.5,
                //               child: DateLineChart(),
                //             ),
                //           ),
                                          
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                
                const SizedBox(height: 24),
                // Expanded(child: _buildDataTable(results)),
                Text('Summary Table', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),

                 _buildDataTable(results)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> launchCheckoutUrl(BuildContext context, String? checkoutUrl) async {
    if (checkoutUrl == null) return;

    final Uri url = Uri.parse(checkoutUrl);

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch checkout')),
      );
    }
  }

  Widget _buildActionButtons(BuildContext context, ReportResultsViewModel viewModel, String reportId) {
    return Row(
      children: [

         ElevatedButton(
          onPressed: () async {
            final billingUrl = await viewModel.generateBillingPortal();
            launchCheckoutUrl(context, billingUrl);

          },
          child: const Text('Test billing portal', style: TextStyle(color: Colors.black),),
        ),
        const SizedBox(width: 16),

        ElevatedButton(
          onPressed: () async {
            final checkoutUrl = await viewModel.generateCheckoutUrl(ProductType.PURCHASE);
            launchCheckoutUrl(context, checkoutUrl);

          },
          child: const Text('Test one-off purchase', style: TextStyle(color: Colors.black),),
        ),
        const SizedBox(width: 16),

        ElevatedButton(
          onPressed: () async {
            final checkoutUrl = await viewModel.generateCheckoutUrl(ProductType.SUBSCRIBE_MONTHLY);
            launchCheckoutUrl(context, checkoutUrl);
          },
          child: const Text('Test monthly subscription', style: TextStyle(color: Colors.black),),
        ),
        const SizedBox(width: 16),

        ElevatedButton(
          onPressed: () async {
            final checkoutUrl = await viewModel.generateCheckoutUrl(ProductType.SUBSCRIBE_YEARLY);
            launchCheckoutUrl(context, checkoutUrl);
          },
          child: const Text('Test yearly subscription', style: TextStyle(color: Colors.black),),
        ),
        const SizedBox(width: 16),

        ElevatedButton(
          onPressed: () async {
            // await viewModel.runReport(reportId);
          },
          child: const Text('Run Report', style: TextStyle(color: Colors.black),),
        ),
        const SizedBox(width: 16),
        if (viewModel.isLoading) ...[
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 8),
          const Text('Loading...'),
        ],
      ],
    );
  }

  Widget _buildSearchTargetInfo(BuildContext context, searchTarget) {
    if (searchTarget == null) return const SizedBox.shrink();

    // debugPrint('searchTarget: $searchTarget');
    // debugPrint('searchTarget.type: ${searchTarget.type}');
    // debugPrint('searchTarget.type.runtimeType: ${searchTarget.type.runtimeType}');
    // debugPrint('searchTarget.type == null: ${searchTarget.type == null}');
    // debugPrint(SearchTargetType.business.label);

    // Force extension usage to avoid Dart import pruning
    // final _ = SearchTargetType.business.label;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Search Target', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        // Text('Type: ${searchTarget.type.label}', style: Theme.of(context).textTheme.bodyMedium),
        // Text('Type: ${searchTarget.type}', style: Theme.of(context).textTheme.bodyMedium),
        Text('Name: ${searchTarget.name}', style: Theme.of(context).textTheme.bodyMedium),
        Text('Description: ${searchTarget.description}', style: Theme.of(context).textTheme.bodyMedium),
        if (searchTarget.url != null)
          Text('URL: ${searchTarget.url}', style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }

  Widget _buildDataTable(List<ReportResult> results) {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          sortColumnIndex: _sortColumnIndex,
          sortAscending: _sortAscending,
          columns: [
            _buildColumn('Prompt', results, (d) => d.prompt),
            _buildColumn('LLM', results, (d) => d.llm.name),
            _buildColumn('Alpha', results, (d) => d.alpha),
            _buildColumn('N', results, (d) => d.n),
            _buildColumn('%', results, (d) => d.pct),
            _buildColumn('Rank', results, (d) => d.meanRank ?? 11.0),
          ],
          rows: results.map((r) {
            return DataRow(
              // onSelectChanged: (_) {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (_) => PromptResultsScreen(reportId: r.reportId),
              //     ),
              //   );
              // },
              cells: [
              // DataCell(Text(r.prompt)),
              DataCell(
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PromptResultsScreen(reportId: r.reportId, promptId: r.promptId),
                      ),
                    );
                  },
                  child: Text(r.prompt),
                ),
              ),
              DataCell(Text(r.llm.name)),
              DataCell(Text(r.alpha.toString())),
              DataCell(Text(r.n.toString())),
              DataCell(Text(r.pctString)),
              DataCell(Text(r.meanRank != null ? r.meanRank!.toStringAsFixed(1) : '-')),
            ]);
          }).toList(),
        ),
      ),
    );
  }

  DataColumn _buildColumn<T>(
    String label,
    List<ReportResult> results,
    Comparable<T> Function(ReportResult d) getField,
  ) {
    final columnIndex = _getColumnIndex(label);
    return DataColumn(
      label: Text(label),
      numeric: T == num,
      onSort: (index, ascending) => _sort<T>(results, getField, columnIndex, ascending),
    );
  }

  int _getColumnIndex(String label) {
    const labels = ['Prompt', 'LLM', 'Alpha', 'N', '%', 'Rank'];
    return labels.indexOf(label);
  }

  // Widget _buildUpgradeOption({
  //   required String title,
  //   required String price,
  //   required String markedUp,
  //   required VoidCallback onTap,
  // }) {
  //   return GestureDetector(
  //     onTap: onTap,
  //     child: Container(
  //       padding: const EdgeInsets.all(12),
  //       width: 100,
  //       decoration: BoxDecoration(
  //         color: Colors.grey[100],
  //         border: Border.all(color: Colors.blueAccent),
  //         borderRadius: BorderRadius.circular(12),
  //       ),
  //       child: Column(
  //         children: [
  //           Text(
  //             title,
  //             style: const TextStyle(fontWeight: FontWeight.bold),
  //           ),
  //           const SizedBox(height: 4),
  //           Text(
  //             price,
  //             style: const TextStyle(
  //               fontSize: 16,
  //               fontWeight: FontWeight.w600,
  //               color: Colors.green,
  //             ),
  //           ),
  //           Text(
  //             markedUp,
  //             style: const TextStyle(
  //               fontSize: 12,
  //               color: Colors.grey,
  //               decoration: TextDecoration.lineThrough,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildUpgradeOption({
    required String title,
    required String price,
    required String markedUp,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.grey[100],
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        hoverColor: Colors.blue[50], // subtle background on hover
        splashColor: Colors.blue.withOpacity(0.2), // ripple effect
        child: Container(
          width: 100,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blueAccent),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                price,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.green,
                ),
              ),
              Text(
                markedUp,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _llmPerformanceCard({
    required String logoImage,
    required String llmName,
    required double accuracy,
    required double rank,
    required bool isBlurred,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                logoImage,
                width: 30.0,
                height: 30.0,
              ),
              const SizedBox(width: 4),
              Text(llmName),
            ],
          ),
          const SizedBox(height: 4),
          BlurredOverlay(
            isBlurred: false, // isBlurred,
            child: CustomPaint(
              painter: RadialPainter(
                proportion: accuracy,
                backgroundColor: Colors.white,
              ),
              child: Center(child: Text("${(accuracy * 100).toStringAsFixed(0)}%")),
            ),
          ),

          const SizedBox(height: 4),

          BlurredOverlay(
            isBlurred: isBlurred,
            onTap: () {
              // showDialog(
              //   context: context,
              //   builder: (_) => AlertDialog(
              //     title: const Text("Upgrade"),
              //     content: const Text("Purchase report for \$19.95 or subscribe for \$9.95/month."),
              //     actions: [
              //       TextButton(
              //         onPressed: () => Navigator.pop(context),
              //         child: const Text("Later"),
              //       ),
              //       ElevatedButton(
              //         onPressed: () {
              //           Navigator.pop(context);
              //           // Navigate to upgrade screen or page
              //         },
              //         child: const Text("Upgrade Now"),
              //       ),
              //     ],
              //   ),
              // );
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Upgrade"),
                  content: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(overscroll: false),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Choose your plan:"),
                          const SizedBox(height: 16),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _buildUpgradeOption(
                                  title: "One-Off",
                                  price: "\$19.99",
                                  markedUp: "\$24.99",
                                  onTap: () async {
                                    Navigator.pop(context);
                                    final viewModel = context.read<ReportResultsViewModel>();
                                    final checkoutUrl = await viewModel.generateCheckoutUrl(ProductType.PURCHASE);
                                    launchCheckoutUrl(context, checkoutUrl);
                                  },
                                ),
                                const SizedBox(width: 8),
                                _buildUpgradeOption(
                                  title: "Monthly",
                                  price: "\$9.99",
                                  markedUp: "\$14.99",
                                  onTap: () async {
                                    Navigator.pop(context);
                                    final viewModel = context.read<ReportResultsViewModel>();
                                    final checkoutUrl = await viewModel.generateCheckoutUrl(ProductType.SUBSCRIBE_MONTHLY);
                                    launchCheckoutUrl(context, checkoutUrl);
                                  },
                                ),
                                const SizedBox(width: 8),
                                _buildUpgradeOption(
                                  title: "Yearly",
                                  price: "\$99.99",
                                  markedUp: "\$149.99",
                                  onTap: () async {
                                    Navigator.pop(context);
                                    final viewModel = context.read<ReportResultsViewModel>();
                                    final checkoutUrl = await viewModel.generateCheckoutUrl(ProductType.SUBSCRIBE_YEARLY);
                                    launchCheckoutUrl(context, checkoutUrl);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Later"),
                    ),
                  ],
                ),
              );



            },
            child: CustomPaint(
              painter: RadialPainter(
                proportion: (10 + 1 - rank) / 10,
                backgroundColor: Colors.white,
              ),
              child: Center(child: Text("#${rank.toStringAsFixed(1)}")),
            ),
          ),
        ],
      ),
    );
  }




}
