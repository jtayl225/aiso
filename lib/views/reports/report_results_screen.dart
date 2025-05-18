import 'package:aiso/view_models/reports_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReportResultsScreen extends StatefulWidget {
  final String reportId;
  const ReportResultsScreen({super.key, required this.reportId});

  @override
  State<ReportResultsScreen> createState() => _ReportResultsScreenState();
}

class _ReportResultsScreenState extends State<ReportResultsScreen> {

  @override
  void initState() {
    super.initState();
    // Trigger data fetch for the report using the ViewModel
    final reportViewModel = context.read<ReportViewModel>();
    reportViewModel.fetchReportResults(widget.reportId);
  }
  
  @override
  Widget build(BuildContext context) {
    return Consumer<ReportViewModel>(
      builder: (context, viewModel, child) {
        final report = viewModel.getReportById(widget.reportId);

        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (report == null) {
          return const Center(child: Text('Report not found'));
        }

        final results = report.results ?? [];

        return Scaffold(
          appBar: AppBar(
            title: Text(report.title),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.read<ReportViewModel>().runReport(report.id);
                  },
                  child: const Text('Run Report'),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Prompt')),
                        DataColumn(label: Text('LLM')),
                        DataColumn(label: Text('Alpha')),
                        DataColumn(label: Text('N')),
                        DataColumn(label: Text('%')),
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