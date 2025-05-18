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
    return const Placeholder();
  }
}