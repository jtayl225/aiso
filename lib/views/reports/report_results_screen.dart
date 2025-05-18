import 'package:aiso/models/report_model.dart';
import 'package:aiso/models/report_results.dart';
import 'package:aiso/models/search_target_type_enum.dart';
import 'package:aiso/view_models/reports_view_model.dart';
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

  @override
  void initState() {
    super.initState();
    // Trigger data fetch for the report using the ViewModel
    final reportViewModel = context.read<ReportViewModel>();
    reportViewModel.fetchReportResults(widget.reportId);
  }

  void _sort<T>(
    Report report,
    Comparable<T> Function(ReportResult d) getField,
    int columnIndex,
    bool ascending,
  ) {
    if (report.results == null) return;

    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;

      report.results!.sort((a, b) {
        final aValue = getField(a);
        final bValue = getField(b);
        final cmp = Comparable.compare(aValue, bValue);
        return ascending ? cmp : -cmp;
      });
    });
  }

  
  @override
  Widget build(BuildContext context) {
    return Consumer<ReportViewModel>(
      builder: (context, viewModel, child) {
        final report = viewModel.getReportById(widget.reportId);

        // if (viewModel.isLoading) {
        //   return const Center(child: CircularProgressIndicator());
        // }

        if (report == null) {
          return const Center(child: Text('Report not found'));
        }

        final results = report.results ?? [];

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
                      builder: (context) => ReportEditorScreen(report: report),
                    ),
                  );
                },
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await context.read<ReportViewModel>().runReport(report.id);
                        await context.read<ReportViewModel>().fetchReportResults(widget.reportId);
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
                      const Text('Loading...')
                    ],
                  ],
                ),

                const SizedBox(height: 16),

                // SEARCH TARGET (Read-only)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Search Target',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),

                    Text(
                      'Type: ${report.searchTarget?.type.label}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),

                    Text(
                      'Name: ${report.searchTarget?.name}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),

                    Text(
                      'Description: ${report.searchTarget?.description}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),

                    if (report.searchTarget?.url != null)
                      Text(
                        'URL: ${report.searchTarget?.url}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    const SizedBox(height: 16),
                  ],
                ),

                const SizedBox(height: 16),


                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      sortColumnIndex: _sortColumnIndex,
                      sortAscending: _sortAscending,
                      columns: [
                        DataColumn(
                          label: Text('Prompt'),
                          numeric: false,
                          onSort: (columnIndex, ascending) => _sort(report, (d) => d.prompt, columnIndex, ascending),
                          ),
                        DataColumn(
                          label: Text('LLM'),
                          numeric: false,
                          onSort: (columnIndex, ascending) => _sort(report, (d) => d.llm.name, columnIndex, ascending),
                          ),
                        DataColumn(
                          label: Text('Alpha'),
                          numeric: true,
                          onSort: (columnIndex, ascending) => _sort(report, (d) => d.alpha, columnIndex, ascending),
                          ),
                        DataColumn(
                          label: Text('N'),
                          numeric: true,
                          onSort: (columnIndex, ascending) => _sort(report, (d) => d.n, columnIndex, ascending),
                          ),
                        DataColumn(
                          label: Text('%'),
                          numeric: true,
                          onSort: (columnIndex, ascending) => _sort(report, (d) => d.pct, columnIndex, ascending),
                          ),
                      ],
                      rows: results.map((result) {
                        return DataRow(
                          cells: [
                            DataCell(Text(result.prompt)),
                            DataCell(Text(result.llm.name)), // Enum name as string
                            DataCell(Text(result.alpha.toString())),
                            DataCell(Text(result.n.toString())),
                            DataCell(Text(result.pctString)),
                          ],
                        );
                      }).toList(),
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