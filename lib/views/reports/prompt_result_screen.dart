import 'package:aiso/constants/app_colors.dart';
import 'package:aiso/view_models/prompt_results_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PromptResultsScreen extends StatefulWidget {
  final String reportId;
  final String promptId;

  const PromptResultsScreen({super.key, required this.reportId, required this.promptId});

  @override
  State<PromptResultsScreen> createState() => _PromptResultsScreenState();
}

class _PromptResultsScreenState extends State<PromptResultsScreen> {
  String? selectedRunId;
  int? selectedEpoch;
  String? selectedLlm;
  bool _filtersInitialized = false;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PromptResultsViewModel(widget.reportId, widget.promptId),
      builder: (context, _) {
        final viewModel = context.watch<PromptResultsViewModel>();

        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // Initialize filters only once after data is loaded
        if (!_filtersInitialized && viewModel.promptResults.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              selectedRunId ??= viewModel.reportRuns.firstOrNull?.id;
              selectedEpoch ??= viewModel.availableEpochs.firstOrNull;
              selectedLlm ??= viewModel.availableLlms.firstOrNull;
              _filtersInitialized = true;
            });
          });
        }

        final allResults = viewModel.promptResults;
        final prompt = viewModel.prompt;

        final filtered = allResults
            .where((e) =>
                (selectedRunId == null || e.runId == selectedRunId) &&
                (selectedEpoch == null || e.epoch == selectedEpoch) &&
                (selectedLlm == null || e.llm == selectedLlm))
            .toList()
          ..sort((a, b) => a.rank.compareTo(b.rank));

        return Scaffold(
          appBar: AppBar(title: const Text('Prompt Results')),
          body: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(overscroll: false),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Filters', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  // Run ID Dropdown
                  Row(
                    children: [
                      const Text(
                        'Report Date:',
                        // style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 12), // spacing between label and dropdown
            
                      Expanded(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: selectedRunId,
                          hint: const Text('Select report date'),
                          items: viewModel.reportRuns
                              .map((r) => DropdownMenuItem(
                                    value: r.id,
                                    child: Text(DateFormat('yyyy-MM-dd HH:mm:ss').format(r.dbTimestamps.createdAt)),
                                  ))
                              .toList(),
                          onChanged: (value) async {
                            if (value != null && value != selectedRunId) {
                              final viewModel = context.read<PromptResultsViewModel>();
                        
                              // Update selectedRunId and fetch new data
                              setState(() {
                                selectedRunId = value;
                                // viewModel.isLoading = true; // Optional: show spinner immediately
                              });
                        
                              await viewModel.fetchPromptResults(widget.reportId, value, widget.promptId);
                        
                              // After data is fetched, reset filters to valid first options
                              setState(() {
                                selectedEpoch = viewModel.availableEpochs.firstOrNull;
                                selectedLlm = viewModel.availableLlms.firstOrNull;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
            
                  // Epoch Dropdown
                  Row(
                    children: [
                       const Text(
                        'Epoch:',
                        // style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 12), // spacing between label and dropdown
                      
                      Expanded(
                        child: DropdownButton<int>(
                          isExpanded: true,
                          value: selectedEpoch,
                          hint: const Text('Select Epoch'),
                          items: viewModel.availableEpochs
                              .map((epoch) => DropdownMenuItem(
                                    value: epoch,
                                    child: Text('Epoch $epoch'),
                                  ))
                              .toList(),
                          onChanged: (value) => setState(() => selectedEpoch = value),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
            
                  // LLM Dropdown
                  Row(
                    children: [
                      const Text(
                        'LLM:',
                        // style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 12), // spacing between label and dropdown
            
                      Expanded(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: selectedLlm,
                          hint: const Text('Select LLM'),
                          items: viewModel.availableLlms
                              .map((llm) => DropdownMenuItem(
                                    value: llm,
                                    child: Text(llm),
                                  ))
                              .toList(),
                          onChanged: (value) => setState(() => selectedLlm = value),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
            
                  Text('Prompt', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text('${prompt?.prompt}', style: Theme.of(context).textTheme.bodyMedium),
                  
                  const SizedBox(height: 16),
            
                  Text('Results', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
            
                  // Display filtered results
                  Expanded(
                    child: filtered.isEmpty
                        ? const Text('No results found.')
                        : ListView.builder(
                            itemCount: filtered.length,
                            itemBuilder: (context, index) {
                              final result = filtered[index];
                              return Card(
                                shape: RoundedRectangleBorder(
                                  side: result.isTarget
                                      ? const BorderSide(color: AppColors.color1, width: 4)
                                      : BorderSide.none,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ListTile(
                                  title: Text(result.name, style: Theme.of(context).textTheme.titleMedium),
                                  subtitle: Text(result.description),
                                  trailing: Text('Rank: ${result.rank}'),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
