import 'package:aiso/view_models/reports_view_model.dart';
import 'package:aiso/views/app_drawer.dart';
import 'package:aiso/views/reports/report_results_screen.dart';
import 'package:aiso/views/reports/reports_editor_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReportsHomeScreen extends StatefulWidget {
  const ReportsHomeScreen({super.key});

  @override
  State<ReportsHomeScreen> createState() => _ReportsHomeScreenState();
}

class _ReportsHomeScreenState extends State<ReportsHomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Reports'),
        actions: [
        IconButton(
          icon: const Icon(Icons.add),
          tooltip: 'Create New Report',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReportEditorScreen(report: null),
              ),
            );
          },
        )
      ],
        ),
      drawer: AppDrawer(),
      body: Consumer<ReportViewModel>(
        builder: (context, reportViewModel, _) {
          final reports = reportViewModel.reports;

          if (reportViewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (reports.isEmpty) {
            return const Center(child: Text('No reports found.'));
          }

          return ListView.builder(
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final currentReport = reports[index];
              return ListTile(
                title: Text(currentReport.title),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReportResultsScreen(reportId: currentReport.id),
                    ),
                  );

                }

              );
            },
          );
        },
      ),
    );
  }

}
