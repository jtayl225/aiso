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

import 'package:aiso/models/report_model.dart';
import 'package:aiso/models/search_target_type_enum.dart';
import 'package:aiso/models/report_results.dart';
import 'package:aiso/view_models/report_results_view_model.dart';
import 'package:aiso/view_models/reports_view_model.dart';
import 'package:aiso/views/reports/line_chart.dart';
import 'package:aiso/views/reports/reports_editor_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    final reportViewModel = context.watch<ReportViewModel>();
    final resultsViewModel = context.watch<ReportResultsViewModel>();

    final Report? report = reportViewModel.getReportById(widget.reportId);
    final results = resultsViewModel.results;
    final searchTarget = resultsViewModel.searchTarget;

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildActionButtons(resultsViewModel, report.id),
              const SizedBox(height: 24),
              _buildSearchTargetInfo(context, searchTarget),
              const SizedBox(height: 24),
              Text("Line chart - Timeseries"),
        
              Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: 300,  // maximum width
                            maxHeight: 300, // maximum height
                          ),
                          child: AspectRatio(
                            aspectRatio: 1.5,
                            child: DateLineChart(),
                          ),
                        ),              
                      ),

                      const SizedBox(height: 8),

                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: 300,  // maximum width
                            maxHeight: 300, // maximum height
                          ),
                          child: AspectRatio(
                            aspectRatio: 1.5,
                            child: DateLineChart(),
                          ),
                        ),
                                        
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              // Expanded(child: _buildDataTable(results)),
               _buildDataTable(results)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(ReportResultsViewModel viewModel, String reportId) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () async {
            await viewModel.runReport(reportId);
          },
          child: const Text('Run Report'),
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

    debugPrint('searchTarget: $searchTarget');
    debugPrint('searchTarget.type: ${searchTarget.type}');
    debugPrint('searchTarget.type.runtimeType: ${searchTarget.type.runtimeType}');
    debugPrint('searchTarget.type == null: ${searchTarget.type == null}');
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
          ],
          rows: results.map((r) {
            return DataRow(cells: [
              DataCell(Text(r.prompt)),
              DataCell(Text(r.llm.name)),
              DataCell(Text(r.alpha.toString())),
              DataCell(Text(r.n.toString())),
              DataCell(Text(r.pctString)),
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
    const labels = ['Prompt', 'LLM', 'Alpha', 'N', '%'];
    return labels.indexOf(label);
  }
}
